# coding: utf-8
module CaseForm
  module Element
    class TextInput < Input
      self.allowed_options << [:cols, :rows, :size, :pattern, :readonly, :maxlength, :escape, :disabled]
      
      private
        def default_options
          options[:cols] ||= 40
          options[:rows] ||= 20
          super
        end
        
        def input
          builder.text_area(specific_method, html_options)
        end
    end
  end
end