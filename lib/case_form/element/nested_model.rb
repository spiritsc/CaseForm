module CaseForm
  module Element
    class NestedModel < Base
      self.allowed_options << [:allow_destroy, :destroy_text, :allow_create, :create_text, 
                               :collection, :fields]
      
      attr_accessor :method
      
      def initialize(builder, method, options={})
        @method = validate_nested_attributes_association(method, builder.object)
        super(builder, options)
      end
      
      def generate(&block)
        block_given? ? nested_attributes(&block) : default_nested_attributes
      end
      
      private
        def default_options
          super
          options[:"data-association"] = method
          # options[:allow_destroy]      = allow_destroy? # FIXME why ||= don't work
          # options[:allow_create]       = allow_create?
          # options[:destroy_text]     ||= destroy_text
          # options[:create_text]      ||= create_text
        end
        
        def validate_nested_attributes_association(method, object)
          raise(NoMethodError, "Not defined :accepts_nested_attributes_for method 
                for association in #{object.class} model!") unless object.respond_to?(:"#{method}_attributes=")
          method
        end
        
        def nested_attributes(&block)
          Element::Fieldset.new(builder).generate(nested_attributes_content(&block).join.html_safe)
        end
        
        def default_nested_attributes
          nested_attributes { |f| f.attributes }
        end
        
        def nested_attributes_method_defined?
          object.respond_to?(:"#{method}_attributes=")
        end
        
        def nested_attributes_content(&block)
          content = []
          content << builder.case_fields_for(method, options, &block)
          content
        end
        
        #def allow_destroy?
        #  if options.has_key?(:allow_destroy)
        #    options[:allow_destroy]
        #  else
        #    association_type?(:has_many) ? object.class.nested_attributes_options[method.to_sym][:allow_destroy] : false
        #  end
        #end
        #
        #def allow_create?
        #  association_type?(:has_many) ? (options.has_key?(:allow_create) ? options[:allow_create] : true) : false
        #end
        #
        #def destroy_text
        #  I18n.t(:"case_form.nested_attributes.destroy", :model => singularize_model_name, :default => "Remove #{singularize_model_name}")
        #end
        #
        #def create_text
        #  I18n.t(:"case_form.nested_attributes.create", :model => singularize_model_name, :default => "Add #{singularize_model_name}")
        #end
        
        def new_model_object
          association_type?(:has_many) ? association.klass.new : object.send(:"build_#{method}")
        end
        
        def singularize_model_name
          method.to_s.singularize.downcase
        end
    end
  end
end