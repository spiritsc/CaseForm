# coding: utf-8
module CaseForm
  module Associations
    def association(*args, &block)
      if block_given?
        case_fields_for(*args, &block)
      else
        options = args.extract_options!
        specified_association(*args, options)
      end
    end
    
    def belongs_to(method, options={})
      options[:as] ? send(options.delete(:as)) : select(method, options)
    end
    
    def has_one(*args, &block)
      raise(ArgumentError, "Association :has_one should be used with block") unless block_given?
      association(*args, &block)
    end
    alias_method :one, :has_one
    
    def has_many(method, options={})
      options[:as] ? send(options.delete(:as)) : checkbox(method, options)
    end
    alias_method :many, :has_many
    alias_method :habtm, :has_many
    
    def case_fields_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      options[:builder] = CaseForm::FormBuilder
      Element::Fieldset.new(self, :class => :inputs).generate(fields_for(record_or_name_or_array, *args << options, &block))
    end
    
    def add_object(method, options={})
      Element::Link.new(self, method, options.merge(:as => :add)).generate
    end
    
    def remove_object(method, options={})
      Element::Link.new(self, method, options.merge(:as => :remove)).generate
    end
    
    private
      def specified_association(*args, options)
        method = args.shift
        if association = object.class.reflect_on_association(method)
          send(association.macro, method, options)
        else
          raise(ArgumentError, "Unknown association! Available association macros: :belongs_to, :has_many and :has_one (only with defined block)")
        end
      end
  end
end