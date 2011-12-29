module RealtimeValidations

  class ValidationsController < ApplicationController

    skip_before_filter :ensure_token_exists
    skip_before_filter :ensure_has_permissions
    before_filter :fetch_token_if_exists

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
      model.send "client_id=", @client.id if @client and model.respond_to? :client_id=
      model.send "user_id=", @client_user.id if @client_user and model.respond_to? :user_id=
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

    def fetch_token_if_exists
      return unless @token
      session = UserSession.find_by_token(@token)
      return unless session
      @client_user = session.user
      @client = session.client
    end

    def remove_unused_args(args)
      [:action, :controller].each { |key| args.delete key }
      args
    end

  end

end