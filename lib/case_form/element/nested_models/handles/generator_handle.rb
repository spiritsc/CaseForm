module CaseForm
  module Element
    class GeneratorHandle < Handle
      self.allowed_options << [:fields]
      
      def generate(&block)
        (block_given? ? new_nested_model_from_block(&block) : new_nested_model_from_fields) + (new_link if collection_association?)
      end
      
      private
        def default_options
          super
          options[:custom][:action] = :new
        end
        
        def new_nested_model_from_block(&block)
          builder.case_fields_for(method, new_nested_model_object, options.merge(custom_options), &block)
        end
        
        def new_nested_model_from_fields
          builder.case_fields_for(method, new_nested_model_object, options.merge(custom_options)) { |f| f.attributes(*nested_model_fields) }
        end
    
        def new_link
          template.link_to(text, "javascript:void(0)", html_options)
        end
        
        def translated_text
          I18n.t(:"case_form.nested_attributes.new", :model => association_human_model_name, :default => default_text)
        end
        
        def default_text
          "New #{association_human_model_name}"
        end
    
        def new_nested_model_object
          collection_association? ? association_class.new : object.send(:"build_#{method}")
        end
        
        def nested_model_fields
          options.delete(:fields)
        end
    end
  end
end