# coding: utf-8
module CaseForm
  module Element
    class CollectionInput < Input
      self.allowed_options << [:disabled, :checked, :selected, :readonly, 
                               :collection, :label_method, :value_method]
                               
      private
        def default_options
          super
          options[:collection] ||= default_collection
        end
        
        def html_options
          super.except(:disabled, :selected, :checked)
        end
        
        def default_collection
          association ? extract_from_association_array(association_class.all) : boolean_collection
        end
        
        def boolean_collection
          [[I18n.t(:"case_form.yes", :default => "Yes"), true], 
           [I18n.t(:"case_form.no", :default => "No"), false]]
        end
        
        def association_class
          association.klass if association
        end
        
        def collection_is_association_class?
          association && options[:collection] == association.klass
        end
        
        def collection
          @collection ||= if collection_is_association_class? #:nodoc only class defined, example: :collection => User
            association_class.all
          else
            options[:collection].to_a
          end
          extract_collection(@collection)
        end
        
        def extract_collection(collection)
          return case collection.first
          when String, Integer, Symbol
            Array.new(collection).collect! { |c| [c, c] }
          when association_class
            extract_from_association_array(collection)
          else 
            collection
          end
        end
        
        def extract_from_association_array(array)
          sample = array.first
          label_method ||= options[:label_method] || collection_methods(:label, sample)
          value_method ||= options[:value_method] || collection_methods(:value, sample)
          array.map { |o| [o.send(label_method), o.send(value_method)] }
        end
        
        def collection_methods(type, sample)
          CaseForm.send(:"collection_#{type}_methods").find { |m| sample.respond_to?(m.to_sym) }
        end
        
        def multiple_collection?
          association ? (association_type?(:belongs_to) ? false : true) : false
        end
        
        def html_options_for_value(value)
          new_options = {}
          [:checked, :selected, :disabled].each do |option|
            next unless options[option]
            new_options[option] = [options[option]].flatten.include?(value) ? true : false
          end
          new_options
        end
        
        def object_input_ids
          @input_ids ||= (association ? object.send(association_method) : [])
        end
        
        def checked_values
          [options.delete(:checked), options.delete(:selected), object_input_ids].flatten.uniq
        end
    end
  end
end