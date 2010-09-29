# coding: utf-8
module CaseForm
  module Element
    class Handle < Base
      self.allowed_options << [:text]
      
      private
        def default_options
          super
          options[:custom] = {}
        end
        
        def text
          options[:text] || translated_text
        end
    end
  end
end