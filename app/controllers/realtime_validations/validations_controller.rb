module RealtimeValidations

  # @private
  # :nodoc:
  class ValidationsController < ApplicationController

    include Controller

    def validate
      args = identify_args
      begin
        field = identify_field
      rescue RealtimeValidationsExceptions::InvalidData
        render :json => { :field => params[:field],
                          :errors => [] }
        return
      end
      model = retrieve_or_create_model args, params[:model]
      send_messages_to_model args, model, field
      model_valid? model
      respond_to_validation retrieve_model_errors(model, field)
    end

    private

    def identify_args
      request.path =~ /^\/validations(.+)$/
      request_path = $1
      remove_unused_args Rails.application.routes.recognize_path(request_path)
    end

    def remove_unused_args(args)
      [:action, :controller].each { |key| args.delete key }
      args
    end

    def identify_field
      raise RealtimeValidationsExceptions::InvalidData unless params[:field] =~ /^[^\[]+\[(\w+)\]$/
      $1
    end

    def retrieve_or_create_model(args, model_name)
      if args.has_key? :id
        model = Object.const_get("#{model_name}".camelize.to_sym).find args[:id]
        args.delete :id
      else
        model = Object.const_get("#{model_name}".camelize.to_sym).new
      end
      model
    end

    def send_messages_to_model(args, model, field)
      value = params[:value]
      validates = params[:validates]
      args.each do |key, value|
        full_key = key.to_s.singularize
        begin
          model.send "#{full_key}=", value
        rescue NoMethodError
        end
      end
      begin
        model.send "#{field}=", value
        model.send "#{field}_confirmation=", validates if validates
      rescue NoMethodError
      end
      before_model_validation model if respond_to? :before_model_validation
    end

    def model_valid?(model)
      begin
        model.valid?
      rescue
      end
    end

    def retrieve_model_errors(model, field)
      model.errors[field.to_sym].uniq
    end

    def respond_to_validation(errors)
      respond_to do |format|
        format.json { render :json => { :field => params[:field],
                                        :errors => errors } }
      end
    end

  end

end
