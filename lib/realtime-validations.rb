module RealtimeValidations

  class RealtimeValidations < Rails::Engine

    initializer 'realtime_validations.init' do |app|
      ActiveSupport.on_load(:action_controller) do
         include RealtimeValidations::ValidationsController
      end
    end

  end

end
