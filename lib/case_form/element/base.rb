# coding: utf-8
module CaseForm
  module Element
    class Base
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
          raise(ArgumentError, "Unknown option(s): #{banned.join(', ')}. Available input options: #{allowed.join(', ')}") unless banned.empty?
        end
        
        def default_options
          options         ||= []
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
        
        def object_column
          object.column_for_attribute(method) if object.class.content_columns.map(&:name).include?(method.to_s)
        end
        
        def object_column_type?(type)
          object_column and object_column.type == type
        end
        
        def association
          object.class.reflect_on_association(method) if object.class.respond_to?(:reflect_on_association)
        end
        
        def association_type?(type)
          association and association.macro == type
        end
        
        def association_method
          case association.macro
          when :belongs_to
            :"#{method.to_s}_id"
          when :has_one
            method
          when :has_many
            :"#{method.to_s.singularize}_ids"
          end
        end
        
        def specific_method
          association ? association_method : method
        end
        
        def new?
          object.new_record?
        end
        
        def action
          new? ? :new : :edit
        end

        def required?
          if options.has_key?(:required)
            options[:required]
          elsif object.class.respond_to?(:validators_on)
            object.class.validators_on(method).any? { |v| v.kind == :presence }
          elsif object_column
            object.column_for_attribute(method).null == false
          else
            CaseForm.all_fields_required
          end
        end
        
        def wrapper_tag
          CaseForm.wrapper_tag
        end
        
        def template
          builder.template
        end
    end
  end
end