# coding: utf-8
module CaseForm
  module Element
    class FileInput < Input
      self.allowed_options << [:multiple]
      
      private
        def input
          builder.file_field(specific_method, html_options)
        end
    end
  end
end