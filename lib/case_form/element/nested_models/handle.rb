# coding: utf-8
module CaseForm
  module Element
    class Handle < Base
      include ElementExt::Associationable
      
      self.allowed_options << [:text]
      
      attr_accessor :method
      
      def initialize(builder, method, options={})
        @method = method #validate_nested_attributes_association(method, builder.object)
        super(builder, options)
      end
      
      private
        def default_options
          super
          options[:custom] = {}
          options[:custom][:association] = method
        end
        
        def text
          options[:text] || translated_text
        end
    end
  end
end