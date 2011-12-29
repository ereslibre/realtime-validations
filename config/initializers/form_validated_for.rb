module ActionView
  module Helpers
    module FormHelper

      def form_validated_for(record, options = {}, &proc)
        options[:html] ||= {}
        options[:html][:validation] = true

        case record
        when String, Symbol
          object_name = record
          object      = nil
        else
          object      = record.is_a?(Array) ? record.last : record
          object_name = options[:as] || ActiveModel::Naming.param_key(object)
        end

        options[:html][:model] = object_name

        form_for record, options, &proc
      end

    end
  end
end
