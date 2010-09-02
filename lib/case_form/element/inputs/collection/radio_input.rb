# coding: utf-8
module CaseForm
  module Element
    class RadioInput < CollectionInput
      private
        def default_options
          super
          options[:checked] = checked_values
        end
        
        def input
          collection.map do |element|
            label, value  = element.first, element.last
            radio_id      = "#{object_name}_#{specific_method}_#{value}".gsub(/]/, "").gsub(/\W/, "_").downcase
            label_options = { :text => label, 
                              :id => "#{radio_id}_label", 
                              :for => radio_id}
            
            builder.radio_button(specific_method, value, html_options.merge(html_options_for_value(value)).merge!(:id => radio_id)) << 
              builder.label(specific_method, label_options)
          end.join.html_safe
        end
    end
  end
end