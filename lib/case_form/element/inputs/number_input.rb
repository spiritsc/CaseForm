# coding: utf-8
module CaseForm
  module Element
    class NumberInput < Input
      self.allowed_options << [:as, :min, :max, :in, :step, :readonly, :disabled]
      
      private
        def default_options
          options[:min]  ||= input_limit(:minimum) 
          options[:max]  ||= input_limit(:maximum)
          options[:step] ||= number_step
          options[:size] ||= CaseForm.input_size
          super
        end
        
        def input
          builder.send("#{input_type}_field", specific_method, html_options)
        end
        
        def input_limit(type)
          validations = object.class.validators_on(method).select { |v| v.kind == :length }
          if validations.any?
            validations.first.options[type]
          elsif object_column_type?(:decimal)
            value = (10**(object_column.precision - object_column.scale))-number_step
            value = value*(-1) if type == :minimum
            value.to_f
          else
            nil
          end
        end
        
        def number_step
          if object_column_type?(:decimal)
            (10**(-object_column.scale)).to_f
          else
            CaseForm.number_step
          end
        end
    end
  end
end