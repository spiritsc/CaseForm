# coding: utf-8
module CaseForm
  module Element
    class Input < Base
      self.allowed_options << [:autofocus, :required, :label, :error, :hint]
      
      attr_accessor :method
      
      def initialize(builder, method, options={})
        @method = method
        super(builder, options)
      end
      
      def generate
        template.content_tag wrapper_tag, contents, wrapper_options
      end
      
      private
        def default_options
          options[:class]    ||= [:input]
          options[:required] ||= required?
        end
        
        def wrapper_options
          wrapper_options = super
          wrapper_options[:class] << :inputs
          wrapper_options
        end
        
        def input_elements
          CaseForm.input_elements
        end
        
        def contents
          contents = []
          input_elements.each do |element| 
            if options[element] == false
              options.delete(element)
              next
            else
              contents << send(element)
            end
          end
          contents.join.html_safe
        end
        
        def label
          Element::Label.new(builder, method, label_options).generate
        end
        
        def label_options
          label_options = options.delete(:label) || {}
          label_options.is_a?(String) ? { :text => label_options } : label_options
        end
        
        def input
          raise(NotImplementedInput)
        end
        
        def input_options
          options.except(:label, :error, :hint)
        end
        
        def error
          Element::SimpleError.new(builder, method, error_options).generate if error?
        end
        
        def error?
          object.errors[method].any? || object.errors[specific_method].any?
        end
        
        def error_options
          options.delete(:error) || {}
        end
        
        def hint
          Element::Hint.new(builder, method, hint_options).generate if hint?
        end
        
        def hint?
          options[:hint].present? || !I18n.t(:"#{object_name}.#{method}", :scope => :"case_form.hints", :default => '').blank?
        end
        
        def hint_options
          hint_options = options.delete(:hint) || {}
          hint_options.is_a?(String) ? { :text => hint_options } : hint_options
        end
        
        def input_size
          validations = object.class.validators_on(method).select { |v| v.kind == :length }
          if validations.any?
            validations.first.options[:maximum]
          else
            CaseForm.input_limit
          end
        end
        
        def input_type
          options[:as]
        end
    end
  end
end