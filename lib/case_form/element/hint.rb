module CaseForm
  module Element
    class Hint < Base
      self.allowed_options << [:text, :tag]
      
      attr_accessor :method
      
      # Initialize hint's object
      #
      def initialize(builder, method, options={})
        @method = method
        super(builder, options)
      end
      
      # Generate hint with defined text and HTML options
      #   
      def generate
        template.content_tag(hint_tag, text, html_options)
      end
      
      private
        # Distribute default options for hint.
        #
        def default_options
          options[:class] ||= [:hint]
          options[:id]    ||= "#{object_name}_#{method}_hint"
        end
        
        # Generate hint's text. By default it use :text option, entered string or translated with I18n method. 
        #
        def text
          if options[:text]
            options.delete(:text)
          elsif method.is_a?(String)
            method
          else
            translated_text
          end
        end
        
        # Translate hint's text with I18n.
        #
        def translated_text
          I18n.t(:"#{object_name}.#{method}", :scope => :"case_form.hints")
        end
        
        # Default hint's tag
        #
        def hint_tag
          options.delete(:tag) || CaseForm.hint_tag
        end
    end
  end
end