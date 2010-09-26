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
        Element::NestedModel.new(self, method, options).generate(&block)
      else
        specified_association(method, options)
      end
    end
    alias_method :belongs_to, :association
    alias_method :has_one, :association
    alias_method :has_many, :association
    alias_method :habtm, :association
    
    # def new_object(association, options={})
    #   Element::AssociationHandle.new(self, association, options.merge(:as => :new)).generate
    # end
    # 
    # def destroy_object(association, options={})
    #   @template.link_to("remove", "#")
    #   #Element::AssociationHandle.new(self, association, options.merge(:as => :destroy)).generate
    # end
    
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
    
      def fields_for_nested_model(name, object, options, block)
        object = object.to_model if object.respond_to?(:to_model)
        # allow_destroy = options[:allow_destroy]
        # destroy_text  = options[:destroy_text]

        @template.content_tag(:div, nil, :class => "#{options[:"data-association"]}_association_inputs") do
          if object.persisted?
            @template.fields_for(name, object, options) do |builder|
              @template.concat(
                block.call(builder) + 
                (builder.hidden_field(:id) unless builder.emitted_hidden_id?) # + 
                # (builder.destroy_object(destroy_text, options) if allow_destroy)
              )
            end
          else
            @template.fields_for(name, object, options, &block)
          end
        end
      end
  end
end