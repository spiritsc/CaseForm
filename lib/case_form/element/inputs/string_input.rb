# coding: utf-8
module CaseForm
  module Element
    class StringInput < Input
      self.allowed_options << [:as, :size, :placeholder, :pattern, :disabled, :readonly, :maxlength]
      
      private
        def default_options
          options[:size] ||= input_size
          super
        end
        
        def input
          builder.send("#{input_type}_field", specific_method, html_options)
        end
    end
  end
end