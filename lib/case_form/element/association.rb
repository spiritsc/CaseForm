# coding: utf-8
module CaseForm
  module Element
    class Association < Base
      self.allowed_options << [:allow_destroy, :destroy_text, :allow_create, :create_text]
      
      attr_accessor :method
      
      def initialize(builder, method, *args)
        options ||= args.extract_options!
        @method   = method
        super(builder, options)
      end
      
      def generate(&block)
        block_given? ? nested_association(&block) : default_nested_association
      end
      
      private
        def default_options
          super
          options[:allow_destroy]  = allow_destroy? # FIXME why ||= don't work
          options[:allow_create]   = allow_create?
          options[:destroy_text] ||= destroy_text
          options[:create_text]  ||= create_text
        end
      
        def nested_association(&block)
          raise(NoMethodError, "Not defined :accepts_nested_attributes_for method for :#{method} association in #{object.class.to_s} model.") unless accept_nested_attributes_defined?
          Element::Fieldset.new(builder).generate(nested_association_content(&block).join.html_safe)
        end
        
        def default_nested_association
          nested_association { |a| a.attributes }
        end
        
        def nested_association_content(&block)
          content = []
          content << builder.case_fields_for(method, options, &block)
          content << create_link if options.delete(:allow_create)
          content
        end
        
        def accept_nested_attributes_defined?
          object.respond_to?(:"#{method}_attributes=")
        end
        
        def nested_attributes_options
          object.class.nested_attributes_options(method.to_sym) if object.class.respond_to?(:nested_attributes_options)
        end
        
        def allow_destroy?
          if options.has_key?(:allow_destroy)
            options[:allow_destroy]
          else
            association_type?(:has_many) ? nested_attributes_options[:allow_destroy] : false
          end
        end
        
        def allow_create?
          association_type?(:has_many) ? (options.has_key?(:allow_create) ? options[:allow_create] : true) : false
        end
        
        def destroy_text
          I18n.t(:"case_form.nested_attributes.destroy", :model => singularize_model_name, :default => "Remove #{singularize_model_name}")
        end
        
        def create_text
          I18n.t(:"case_form.nested_attributes.create", :model => singularize_model_name, :default => "Add #{singularize_model_name}")
        end
        
        def create_link
          template.link_to(options.delete(:create_text), "javascript:void(0)", :remote => true, :"data-association" => method, :"data-action" => :add)
        end
        
        def singularize_model_name
          method.to_s.singularize.downcase
        end
    end
  end
end