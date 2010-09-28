module CaseForm
  module Element
    class DestructorHandle < Handle
      self.allowed_options << [:as]
      
      def generate
        send("destroy_#{handle_type}")
      end
      
      private
        def default_options
          super
          options[:custom][:action] = :destroy
          options[:as]            ||= :checkbox
        end
        
        def destroy_link
          builder.hidden_field(:_destroy) + template.link_to(text, "javascript:void(0)", html_options)
        end
        
        def destroy_checkbox
          builder.check_box(:_destroy) << builder.label(specific_method, :text => text)
        end
        
        def translated_text
          association_human_model_name = method
          I18n.t(:"case_form.nested_attributes.destroy", :model => association_human_model_name, :default => default_text)
        end
        
        def default_text
          association_human_model_name = method
          "Destroy #{association_human_model_name}"
        end
    
        def handle_type
          options[:as]
        end
    end
  end
end