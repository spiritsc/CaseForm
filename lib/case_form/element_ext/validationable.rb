module CaseForm
  module ElementExt
    module Validationable
      def validationable?
        object.class.respond_to?(:validators_on)
      end
      
      def method_validations
        object.class.validators_on(method)
      end
    end
  end
end