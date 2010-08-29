module CaseForm
  module Element
    class Label < Base
      self.allowed_options << [:for, :text, :required]
      
      attr_accessor :method
      
      # Initialize label object
      #
      def initialize(builder, method, options={})
        @method = method
        super(builder, options)
      end
      
      # Generate label with defined text and HTML options
      #
      def generate
        template.label(object_name, method, text, html_options)
      end
            
      private
        # Distribute default options for label.
        #
        def default_options
          options[:class] ||= [:label]
          options[:id]    ||= "#{object_name}_#{specific_method}_label"
        end
        
        # Generate label text with optional required symbol.
        #
        def text
          @text  = options.delete(:text) || translated_text
          @text += CaseForm.require_symbol if required?
          @text
        end
        
        # Translate label text with I18n.
        # 
        def translated_text
          lookups = []
          lookups << :"activerecord.attributes.#{object_name}.#{method}"
          lookups << :"activemodel.attributes.#{object_name}.#{method}"
          lookups << :"case_form.attributes.#{object_name}.#{method}"
          lookups << method.to_s.humanize
          I18n.t(lookups.shift, :default => lookups)
        end
    end
  end
end