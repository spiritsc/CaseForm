module CaseForm
  module FormHelper
    @@default_field_error_proc = nil

    # Override the default ActiveRecordHelper behaviour of wrapping the input.
    # This gets taken care of semantically by adding an error class to the wrapper tag
    # containing the input.
    FIELD_ERROR_PROC = proc do |html_tag, instance_tag|
      html_tag
    end
    
    def with_custom_field_error_proc(&block)
      @@default_field_error_proc = ::ActionView::Base.field_error_proc
      ::ActionView::Base.field_error_proc = FIELD_ERROR_PROC
      result = yield
      ::ActionView::Base.field_error_proc = @@default_field_error_proc
      result
    end
    
    # Define case_form_for and case_fields_for
    [:form_for, :fields_for].each do |helper|
      class_eval <<-METHOD, __FILE__, __LINE__
        def case_#{helper}(record_or_name_or_array, *args, &block)
          options = args.extract_options!
          options[:builder] = CaseForm::FormBuilder
          css_class = case record_or_name_or_array
            when String, Symbol then record_or_name_or_array.to_s
            when Array then dom_class(record_or_name_or_array.last)
            else dom_class(record_or_name_or_array)
          end
          options[:html] ||= {}
          options[:html][:class] = "case_form \#{css_class} \#{options[:html][:class]}".strip
    
          with_custom_field_error_proc do
            #{helper}(record_or_name_or_array, *(args << options), &block)
          end
        end
      METHOD
    end
    
    # Define remote_case_form_for
    class_eval <<-METHOD
      def remote_case_form_for(record_or_name_or_array, *args, &block)
        options = args.extract_options!
        options[:remote] = true
          
        case_form_for(record_or_name_or_array, *(args << options), &block)
      end
    METHOD
  end
end

# Include CaseForm
ActionView::Helpers.send :include, CaseForm::FormHelper