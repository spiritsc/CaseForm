# coding: utf-8
module CaseForm
  module Element
    class SearchInput < Input
      self.allowed_options -= [:required, :error, :hint]
      
      private
        def wrapper_options
          wrapper_options = super
          wrapper_options[:class] << :search
          wrapper_options
        end
        
        def contents
          contents = []
          [:label, :input].each do |element| 
            if options[element] == false
              options.delete(element)
              next
            else
              contents << send(element)
            end
          end
          contents.join.html_safe
        end
        
        def input
          builder.search_field(specific_method, html_options)
        end
    end
  end
end