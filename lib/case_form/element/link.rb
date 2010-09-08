# coding: utf-8
module CaseForm
  module Element
    class Link < Base
      self.allowed_options << [:text, :as, :target]
      
      attr_accessor :method
      
      def initialize(builder, method, options={})
        @method = method
        super(builder, options)
      end
      
      def generate
        extra_field + link
      end
      
      private
        def default_options
          options[:custom] = {}
          options[:custom][:association] = method.to_sym
          options[:custom][:action] = options[:as]
          #super
        end
        
        def link
          template.link_to(text, nil, :remote => true)
        end
        
        def text
          link_type.to_s.upcase
        end
        
        def translated_text
          
        end
        
        def extra_field
          send("#{link_type}_field")
        end
        
        def add_field
          nil
        end
        
        def remove_field
          Element::HiddenInput.new(builder, :_destroy).generate
        end
        
        def link_type
          options[:as]
        end
    end
  end
end