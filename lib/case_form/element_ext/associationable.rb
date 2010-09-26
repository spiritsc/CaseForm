module CaseForm
  module ElementExt
    module Associationable
      def association
        object.class.reflect_on_association(method) if object.class.respond_to?(:reflect_on_association)
      end
            
      def association_class
        association.klass if association
      end
      
      def association_type?(type)
        association and association.macro == type
      end
      
      def association_method
        case association.macro
        when :belongs_to
          :"#{method.to_s}_id"
        when :has_one
          method
        when :has_many
          :"#{method.to_s.singularize}_ids"
        end
      end
      
      def specific_method
        association ? association_method : method
      end
    end
  end
end