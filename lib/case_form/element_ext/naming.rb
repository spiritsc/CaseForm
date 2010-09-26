module CaseForm
  module ElementExt
    module Naming
      def sanitized_object_name
        object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
      end
      
      def singularize_model_name
        method.to_s.singularize.downcase
      end
    end
  end
end