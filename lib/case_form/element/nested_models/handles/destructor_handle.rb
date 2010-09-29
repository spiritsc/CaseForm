# coding: utf-8
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
          options[:as]            ||= :checkbox
          options[:custom][:action] = :destroy if link?
        end
        
        def destroy_link
          builder.hidden_field(:_destroy) + template.link_to(text, "javascript:void(0)", html_options)
        end
        
        def destroy_checkbox
          builder.checkbox(:_destroy, :label => text)
        end
        
        def translated_text
          I18n.t(:"case_form.nested_attributes.destroy", :model => object_human_model_name, :default => default_text)
        end
        
        def default_text
          "Destroy #{object_human_model_name}"
        end
    
        def handle_type
          options[:as]
        end
        
        def link?
          handle_type == :link
        end
        
        def checkbox?
          handle_type == :checkbox
        end
    end
  end
end