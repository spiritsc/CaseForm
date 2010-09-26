module CaseForm
  module ElementExt
    module Columnable
      def columnable?
        object.class.columns.map(&:name).include?(method.to_sym)
      end
      
      def object_column
        object.column_for_attribute(method) if columnable?
      end
      
      def object_column_type?(type)
        object_column and object_column.type == type
      end
      
      def specific_method
        method
      end
    end
  end
end