# coding: utf-8
module CaseForm
  module Element
    class NestedModel < Base
      include ElementExt::Associationable
      
      self.allowed_options << [:destructor, :generator, :collection, :fields]
      
      attr_accessor :method
      
      def initialize(builder, method, options={})
        @method = validate_nested_attributes_association(method, builder.object)
        super(builder, options)
      end
      
      def generate(&block)
        Element::Fieldset.new(builder).generate(contents(&block))
      end
      
      private
        def default_options
          super
          options[:custom]               = {}
          options[:custom][:association] = method
          options[:collection]         ||= default_collection
          options[:destructor]         ||= allow_destroy?
        end
        
        def nested_attributes_method_defined?
          object.respond_to?(:"#{method}_attributes=")
        end
        
        def contents(&block)
          contents = []
          [:nested_model, :generator].each do |element|
            if options[element] == false
              options.delete(element)
              next
            else
              contents << send(element, &block)
            end
          end
          contents.join.html_safe
        end
        
        def nested_model(&block)
          if block_given?
            builder.case_fields_for(method, collection, options.merge(custom_options), &block)
          else
            builder.case_fields_for(method, collection, options.merge(custom_options)) { |f| f.attributes(*nested_model_fields) }
          end
        end
        
        def generator(&block)
          Element::GeneratorHandle.new(builder, method, generator_options).generate(&block) if collection_association?
        end
        
        def generator_options
          generator_options = options.delete(:generator) || {}
          generator_options.is_a?(String) ? { :text => generator_options } : generator_options
          generator_options.merge({ :fields => nested_model_fields })
        end
        
        def allow_destroy?
          collection_association? ? object.class.nested_attributes_options[method.to_sym][:allow_destroy] : false
        end
        
        def default_collection
          object.send(method) || (new_nested_model unless collection_association?)
        end
        
        def new_nested_model
          collection_association? ? association_class.new : object.send(:"build_#{method}")
        end
        
        def nested_model_fields
          options[:fields]
        end
        
        def collection
          collection = options.delete(:collection)
          collection unless collection.nil?
        end
    end
  end
end