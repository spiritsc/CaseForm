# coding: utf-8
module CaseForm
  module Associations
    def association(method, *args, &block)
      validate_association_method(method)
      send(object_association(method).macro, method, *args, &block)
    end
    
    def belongs_to(method, *args, &block)
      nested_attributes?(method, *args, &block) ? Element::Association.new(self, method, *args).generate(&block) : association_input(method, *args)
    end
    
    def has_one(method, *args, &block)
      raise(ArgumentError, "Association :has_one should be used with block") unless block_given?
      validate_association_method(method)
      Element::Association.new(self, method, *args).generate(&block)
    end
    alias_method :one, :has_one
    
    def has_many(method, *args, &block)
      nested_attributes?(method, *args, &block) ? Element::Association.new(self, method, *args).generate(&block) : association_input(method, *args)
    end
    alias_method :many, :has_many
    alias_method :habtm, :has_many
    
    def case_fields_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      options[:builder] = CaseForm::FormBuilder
      fields_for(record_or_name_or_array, *(args << options), &block)
    end
    
    def remove_object(text, options={})
      hidden_field(:_destroy) + @template.link_to(text, "javascript:void(0)", :remote => true, :"data-action" => :remove, :"data-association" => options[:"data-association"])
    end
    
    private
      def validate_association_method(method)
        raise(ArgumentError, ":#{method} method does not look like association method.") unless object_association(method)
      end
      
      def nested_attributes?(method, *args, &block)
        validate_association_method(method)
        case
        when args.extract_options!.has_key?(:as) then false
        when block_given?                        then true
        else
          accept_nested_attributes_defined?(method)
        end
      end
      
      def accept_nested_attributes_defined?(method)
        object.respond_to?(:"#{method}_attributes=")
      end
      
      def association_input(method, *args)
        options = args.extract_options!
        input   = options.has_key?(:as) ? options.delete(:as) : (object_association(method).macro == :has_many ? :checkbox : :select)
        send(input, method, options)
      end
      
      def object_association(method)
        object.class.reflect_on_association(method) if object.class.respond_to?(:reflect_on_association)
      end
      
      def fields_for_nested_model(name, object, options, block)
        object = object.to_model if object.respond_to?(:to_model)
        allow_destroy = options[:allow_destroy]
        destroy_text  = options[:destroy_text]
        
        @template.content_tag(:div, nil, :class => "#{options[:"data-association"]}_association_inputs") do
          if object.persisted?
            @template.fields_for(name, object, options) do |builder|
              block.call(builder)
              @template.concat((builder.hidden_field(:id) unless builder.emitted_hidden_id?) + (builder.remove_object(destroy_text, options) if allow_destroy))
            end
          else
            @template.fields_for(name, object, options, &block)
          end
        end
      end
  end
end