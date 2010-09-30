# coding: utf-8
module CaseForm
  module Element
    class NestedModel < Base
      include ElementExt::Associationable
      
      self.allowed_options << [:destructor, :generator, :collection, :fields]
      
      attr_accessor :method, :block
      
      def initialize(builder, method, options={}, &block)
        @method = validate_nested_attributes_association(method, builder.object)
        @block  = block
        super(builder, options)
      end
      
      def generate
        contents = []
        contents << nested_model_contents
        contents << builder.new_object(method, :fields => (block.nil? ? options[:fields] : block)) if allow_create?
        contents.join.html_safe
      end
      
      private
        def default_options
          super
          options[:custom]               = {}
          options[:custom][:association] = method
          options[:collection]         ||= default_collection
          options[:fields]             ||= default_fields
        end
        
        def nested_attributes_method_defined?
          object.respond_to?(:"#{method}_attributes=")
        end
        
        def nested_model_contents
          contents = []
          nested_models = [collection].flatten.compact
          nested_models.each do |object|
            contents << nested_model(object)
          end
          Element::Fieldset.new(builder, :class => "#{method}_association").generate(contents.join.html_safe) unless contents.blank?
        end
        
        def nested_model(object)
          template.content_tag(:div, nil, :class => "#{method}_association_inputs") do
            builder.case_fields_for(method, object) do |b|
              unless block.nil?
                block.call(b) << (b.destroy_object if allow_destroy?)
              else
                fields = [options[:fields]].flatten 
                fields << :_destroy if allow_destroy?
                template.concat(b.attributes(*fields))
              end
            end
          end
        end
        
        def allow_create?
          if collection_association?
            if options.has_key?(:generator)
              options[:generator] != false
            elsif block.is_a?(Proc)
              false
            else
              true
            end
          else
            false
          end
        end
        
        def allow_destroy?
          if collection_association?
            if options.has_key?(:desctructor)
              options[:destructor] != false
            elsif block.is_a?(Proc)
              false
            else 
              object.class.nested_attributes_options[method.to_sym][:allow_destroy]
            end
          else
            false
          end
        end
        
        def default_collection
          object.send(method) || (new_nested_model unless collection_association?)
        end
        
        def default_fields
          association_class.content_columns.map(&:name).map(&:to_sym) - CaseForm.locked_columns
        end
        
        def new_nested_model
          collection_association? ? association_class.new : object.send(:"build_#{method}")
        end
        
        def collection
          options[:collection]
        end
    end
  end
end