# coding: utf-8
module CaseForm
  module Associations
    def association(method, *args, &block)
      if association = object.class.reflect_on_association(method)
        send(association.macro, method, *args, &block)
      else
        raise(ArgumentError, "Unknown association! Available association macros: :belongs_to, :has_many and :has_one (only with defined block)")
      end
    end
    
    def belongs_to(method, *args, &block)
      Element::OneToOneAssociation.new(self, method, *args).generate(&block)
    end
    
    def has_one(method, *args, &block)
      raise(ArgumentError, "Association :has_one should be used with block") unless block_given?
      Element::OneToOneAssociation.new(self, method, *args).generate(&block)
    end
    alias_method :one, :has_one
    
    def has_many(method, *args, &block)
      Element::CollectionAssociation.new(self, method, *args).generate(&block)
    end
    alias_method :many, :has_many
    alias_method :habtm, :has_many
    
    def case_fields_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      options[:builder] = CaseForm::FormBuilder
      fields_for(record_or_name_or_array, *(args << options), &block)
    end
    
    private
      # Add HTML div for each associated object
      #
      def fields_for_nested_model(name, object, options, block)
        @template.content_tag(:div, super, :class => :association_inputs)
      end
  end
end