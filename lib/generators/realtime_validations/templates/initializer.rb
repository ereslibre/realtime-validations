module RealtimeValidations

  module Controller

    #
    # Called when this module is included in the ValidationsController.
    #
    # Here, you could add or remove new before and after filters, for instance.
    #
    # Example:
    #
    #   base.skip_before_filter :some_applicationcontroller_filter
    #   base.before_filter :some_helper_method
    #
    def self.included(base)
    end

    #
    # Called before model is validated. The model has already been filled with all the needed
    # information in order to check whether is valid or not. Here, you could also add some
    # extra information that has meaning for your system, as a client_id, a session_id, a
    # user_id or something similar.
    #
    # Example:
    #
    #   model.client_id = @client.id if @client and model.respond_to? :client_id=
    #   model.user_id = @user.id if @user and model.respond_to? :user_id=
    #
    # This is very important for validations on your model of the type:
    #
    #   validates :name, :presence => true, :uniqueness => { :scope => :client_id }
    #
    def before_model_validation(model)
    end

  end

end