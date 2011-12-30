module RealtimeValidations

  class ValidationsController < ApplicationController

    include Controller

    def validate
      model_name = params[:model]
      request.path =~ /^\/validations(.+)$/
      request_path = $1
      args = remove_unused_args Rails.application.routes.recognize_path(request_path)
      field = params[:field]
      field =~ /^[^\[]+\[(\w+)\]$/
      field = $1
      value = params[:value]
      validates = params[:validates]
      if args.has_key? :id
        model = Object.const_get("#{model_name}".camelize.to_sym).find args[:id]
        args.delete :id
      else
        model = Object.const_get("#{model_name}".camelize.to_sym).new
      end
      args.each do |key, value|
        full_key = key.to_s.singularize
        model.send "#{full_key}=", value if model.respond_to? full_key.to_sym
      end
      model.send "#{field}=", value
      model.send "#{field}_confirmation=", validates if validates
      before_model_validation model if respond_to? :before_model_validation
      begin
        model.valid?
      rescue
      end
      errors = model.errors[field.to_sym].uniq
      respond_to do |format|
        format.json { render :json => { :field => params[:field],
                                        :errors => errors } }
      end
    end

    private

    def remove_unused_args(args)
      [:action, :controller].each { |key| args.delete key }
      args
    end

  end

end