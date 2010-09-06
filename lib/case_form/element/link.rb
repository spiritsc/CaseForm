# coding: utf-8
module CaseForm
  module Element
    class Link < Base
      self.allowed_options << [:text, :as, :target]
      
      def generate
        template.link_to(text, nil, :remote => true)
      end
      
      private
        def default_options
          super
          options[:custom] = {}
          options[:custom][:association] = method.to_sym
          options[:custom][:action] = options.delete(:as)
          
        end
        
        def text
          
        end
        
        def translated_text
          
        end
    end
  end
end