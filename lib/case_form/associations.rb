# coding: utf-8
module CaseForm
  module Associations
    def association(*args, &block)
      if block_given?
        case_fields_for(*args, &block)
      else
        options = args.extract_options!
        specified_association(method, options)
      end
    end
    
    def belongs_to(method, options={})
      options[:as] ? send(options.delete(:as)) : select(method, options)
    end
    
    def has_one(*args, &block)
      raise("Association has_one should have a block") unless block_given?
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
      fields_for(record_or_name_or_array, *args << options, &block)
    end
    
    private
      def specified_association
        if association = object.class.reflect_on_association(method)
          case association.macro
          when :belongs_to then belongs_to(method, options)
          when :has_one    then has_one(method, options)
          when :has_many   then has_many(method, options)
          end
        else
          raise("Unknown association! Available association macros: :belongs_to, :has_one and :has_many")
        end
      end
  end
end