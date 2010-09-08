# coding: utf-8
module CaseForm
  module Element
    class Association < Base
      self.allowed_options << [:as]
      
      attr_accessor :method
      
      def initialize(builder, method, *args)
        options ||= args.extract_options!
        @method   = method
        super(builder, options)
        raise(ArgumentError, ":#{method} method does not look like association method.") unless association
      end
      
      def generate(&block)
        block_given? ? nested_association(&block) : specified_association
      end
      
      private
        def nested_association(&block)
          raise(NoMethodError, "Not defined :accepts_nested_attributes_for method for :#{method} association in #{object.class.to_s} model.") unless accept_nested_attributes_defined?
          Element::Fieldset.new(builder).generate(builder.case_fields_for(method, options, &block))
        end
        
        def default_nested_association
          nested_association { |a| a.attributes }
        end
        
        def association_input
          builder.send(association_input_type, method, options)
        end
        
        def association_input_type
          options.has_key?(:as) ? options.delete(:as).to_sym : (association_type?(:has_many) ? :checkbox : :select)
        end
        
        def specified_association
          if options.has_key?(:as)
            association_input
          elsif accept_nested_attributes_defined?
            default_nested_association
          end
        end
        
        def accept_nested_attributes_defined?
          object.respond_to?(:"#{method}_attributes=")
        end
    end
  end
end