# coding: utf-8
module CaseForm
  module Element
    class Button < Base
      self.allowed_options << [:disabled, :text, :as]
      
      # Generate button with defined text and HTML options
      #
      def generate
        template.content_tag wrapper_tag, button, wrapper_options
      end
      
      private
        # Distribute default options for button.
        #
        def default_options
          options[:as]       ||= :commit
          options[:class]    ||= [:button]
          options[:id]       ||= "#{builder.object_name}_#{button_type}"
          options[:type]     ||= button_type
          options[:name]     ||= button_type
        end
        
        # Distribute wrapper options for button.
        #
        def wrapper_options
          wrapper_options = super
          wrapper_options[:class] << :element
          wrapper_options
        end
        
        # Create submit button
        #
        def button
          builder.submit(text, html_options)
        end
        
        # Generate button text.
        #
        def text
          options.delete(:text) || translated_text
        end
        
        # Translate button text
        def translated_text
          lookups = []
          lookups << :"#{builder.object_name}.#{button_type}"
          lookups << :"#{button_type}"
          lookups << default_button_text
          I18n.t(lookups.shift, :scope => :"case_form.buttons", :default => lookups)
        end
        
        # Default button text
        def default_button_text
          button_type == :submit ? (new? ? "Create" : "Update") : "Reset"
        end
        
        # Button type (available: :commit and :reset)
        def button_type
          options[:as]
        end
    end
  end
end