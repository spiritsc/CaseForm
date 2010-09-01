# coding: utf-8
module CaseForm
  module Element
    class TextInput < Input
      self.allowed_options << [:cols, :rows, :readonly, :maxlength, :escape, :disabled, :placeholder]
      
      private
        def default_options
          options[:cols] ||= CaseForm.textarea_cols
          options[:rows] ||= CaseForm.textarea_rows
          super
        end
        
        def input
          builder.text_area(specific_method, html_options)
        end
    end
  end
end