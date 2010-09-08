# coding: utf-8
module CaseForm
  module Element
    class CheckboxInput < CollectionInput
      self.allowed_options << [:unchecked_value, :allow_multiple]
      
      private
        def default_options
          super
          options[:unchecked_value] ||= ''
          options[:checked]           = checked_values
          options[:allow_multiple]  ||= multiple_collection?
          options[:multiple]          = true if options[:allow_multiple] == true
        end
        
        def input
          collection.map do |element|
            label, value  = element.first, element.last
            checkbox_id   = "#{sanitized_object_name}_#{specific_method}_#{value}"
            label_options = { :text  => label, 
                              :id    => "#{checkbox_id}_label", 
                              :class => :inline_label,
                              :for   => checkbox_id }
            
            builder.check_box(specific_method, html_options.merge(html_options_for_value(value).merge!(:id => checkbox_id)), value, options[:unchecked_value]) <<
              builder.label(specific_method, label_options)
          end.join.html_safe
        end
        
        def boolean_collection
          [super.first]
        end
    end
  end
end