# coding: utf-8
module CaseForm
  module Associations
    def association(method, *args, &block)
      association = object.class.reflect_on_association(method)
      raise(ArgumentError, "Association :#{method} not found in #{object.class} model") unless association
      
      options = args.extract_options!
      
      if options.has_key?(:as) && association.macro != :has_one
        type, input_types = options.delete(:as), [:checkbox, :radio, :select]
        raise(ArgumentError, "Unknown input type: #{type}. Available types: #{input_types.join(', ')}") unless input_types.include?(type.to_sym)
        send(type, method, options)
      elsif block_given? || object.respond_to?("#{method}_attributes=")
        Element::NestedModel.new(self, method, options, &block).generate
      else
        specified_association(method, options)
      end
    end
    alias_method :belongs_to, :association
    alias_method :has_one, :association
    alias_method :has_many, :association
    alias_method :habtm, :association
    
    def new_object(method, options={})
      Element::GeneratorHandle.new(self, method, options).generate
    end
    
    def destroy_object(options={})
      Element::DestructorHandle.new(self, options).generate
    end
    
    def case_fields_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      options[:builder] = CaseForm::FormBuilder
      fields_for(record_or_name_or_array, *(args << options), &block)
    end
    
    private
      def specified_association(method, options)
        input = case object.class.reflect_on_association(method.to_sym).macro
        when :belongs_to then :select
        when :has_many   then :checkbox
        else
          raise(ArgumentError, ":has_one association is supported only with nested attributes!")
        end
        send(input, method, options)
      end
  end
end