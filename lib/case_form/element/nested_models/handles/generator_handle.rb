# coding: utf-8
module CaseForm
  module Element
    class GeneratorHandle < Handle
      include ElementExt::Associationable
      
      self.allowed_options << [:fields]
      
      attr_accessor :method
      
      def initialize(builder, method, options={})
        @method = method
        super(builder, options)
      end
      
      def generate
        Element::Fieldset.new(builder, :class => "new_#{method}_association").generate(new_nested_model + new_link)
      end
      
      private
        def default_options
          super
          options[:custom][:association] = method
          options[:custom][:action]      = :new
          options[:fields]             ||= default_fields
        end
        
        def new_nested_model
          template.content_tag(:div, nil, :class => "#{method}_association_inputs") do
            if options[:fields].is_a?(Proc)
              builder.case_fields_for(method, association_class.new, &block)
            else
              builder.case_fields_for(method, association_class.new) { |b| template.concat(b.attributes(*options[:fields])) }
            end
          end
        end
    
        def new_link
          template.link_to(text, "javascript:void(0)", html_options)
        end
        
        def translated_text
          I18n.t(:"case_form.nested_attributes.new", :model => association_human_model_name, :default => default_text)
        end
        
        def default_text
          "New #{association_human_model_name}"
        end
        
        def default_fields
          association_class.content_columns.map(&:name).map(&:to_sym) - CaseForm.locked_columns
        end
    end
  end
end