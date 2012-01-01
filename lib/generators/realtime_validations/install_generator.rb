require 'rails/generators'

module RealtimeValidations

  module Generators

    class InstallGenerator < Rails::Generators::Base

      source_root File.join(File.dirname(__FILE__), 'templates')

      def copy_initializer_file
        copy_file 'initializer.rb', 'config/initializers/realtime_validations_initializer.rb'
        copy_file 'realtime_validations.custom.js', 'app/assets/javascripts/realtime_validations.custom.js'
      end

    end

  end

end
