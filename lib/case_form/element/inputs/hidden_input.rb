# coding: utf-8
module CaseForm
  module Element
    class HiddenInput < Input
      self.allowed_options -= [:autofocus, :required]
      
      def generate
        builder.hidden_field(specific_method, html_options)
      end
      
      private
        def default_options
          options[:class] ||= [:input, :hidden]
        end
    end
  end
end