require 'case_form/element_ext/naming'
require 'case_form/element_ext/columnable'
require 'case_form/element_ext/validationable'
require 'case_form/element_ext/associationable'

# coding: utf-8
module CaseForm
  module Element
    class Base
      include ElementExt::Naming
      
      HTML_OPTIONS = [:id, :class, :style, :readonly, :disabled, :type, :name,
                      :autofocus, :placeholder, :required, :multiple, :checked, :selected, 
                      :for, :min, :max, :step, :pattern, :size, :maxlength, :cols, :rows]
      
      class_inheritable_accessor :allowed_options
      self.allowed_options = [:custom, :id, :class, :style]

      attr_accessor :builder, :options

      def initialize(builder, options={})
        @builder, @options = builder, options.symbolize_keys!
        validate_options
        default_options
      end

      private
        def validate_options #:nodoc same as assert_valid_keys for Hash
          allowed = self.class.allowed_options.flatten
          banned = options.keys - allowed
          raise(ArgumentError, "Unknown option(s): #{banned.join(', ')}. Available options: #{allowed.join(', ')}") unless banned.empty?
        end
        
        def default_options
          options         ||= {}
          options[:class] ||= []
          options[:id]    ||= []
        end
        
        def wrapper_options
          wrapper_options = {}
          wrapper_options[:class] = []
          wrapper_options
        end
        
        def html_options
          options.slice(*HTML_OPTIONS).merge(custom_options)
        end
        
        def custom_options
          custom_options = {}
          return custom_options unless options.has_key?(:custom)
          raise(ArgumentError, "Invalid :custom options! Custom options should be hash with key and value.") unless options[:custom].is_a?(Hash)
          options.delete(:custom).each { |key, value| custom_options[:"data-#{key}"] = value }
          custom_options
        end
        
        def object_name
          @builder.object_name
        end

        def object
          @builder.object
        end
                
        def template
          builder.template
        end
        
        def required?
          if options.has_key?(:required)
            options[:required]
          elsif respond_to?(:validationable?) && validationable? && method_validations.any? { |v| v.kind == :presence }
            true
          elsif respond_to?(:columnable?) && object_column.present? && object_column.null == false
            true
          else
            CaseForm.all_fields_required
          end
        end
        
        def new?
          object.new_record?
        end
        
        def action
          new? ? :new : :edit
        end
        
        def wrapper_tag
          CaseForm.wrapper_tag
        end
    end
  end
end