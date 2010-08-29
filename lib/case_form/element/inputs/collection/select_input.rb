# coding: utf-8
module CaseForm
  module Element
    class SelectInput < CollectionInput
      self.allowed_options << [:prompt, :blank, :allow_multiple, :size]
      
      private
        def default_options
          super
          options[:selected]         = checked_values
          options[:allow_multiple] ||= multiple_collection?
          options[:multiple]         = true if options[:allow_multiple] == true
          options[:blank]          ||= true
          options[:include_blank]    = options.delete(:blank)
        end
        
        def input
          template.select(object_name, specific_method, collection, options, html_options)
        end
    end
  end
end