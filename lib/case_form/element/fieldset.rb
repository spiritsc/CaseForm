# coding: utf-8
module CaseForm
  module Element
    class Fieldset < Base
      self.allowed_options << [:text]
      
      # Generate fieldset with defined arguments or block.
      # Optional add legend tag if determined in options.
      #
      def generate(*args, &block)
        contents, legend = [], text
        contents << template.content_tag(:legend, legend) if legend
        contents << if block_given? 
          template.capture(&block) 
        else
          args
        end
        template.content_tag(:fieldset, contents.join.html_safe, html_options)
      end
      
      private
        # Distribute default options for fieldset.
        #
        def default_options
          options[:class] ||= [:fieldset]
        end
        
        # Fieldset legend text.
        #
        def text
          options.delete(:text)
        end
    end
  end
end