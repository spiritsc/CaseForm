# coding: utf-8
module CaseForm
  module Element
    class DateInput < Input
      self.allowed_options -= [:id]
      self.allowed_options << [:placeholder, :readonly, :elements, :separator, 
                               :year, :start_year, :end_year, :month, :short_month, :day, 
                               :default, :date, :prompt, :blank, :disabled]
      
      private
        def default_options
          options[:elements]        ||= [:year, :month, :day]
          options[:order]             = options.delete(:elements)
          options[:discard_year]      = discard_element?(:year)
          options[:discard_month]     = discard_element?(:month)
          options[:discard_day]       = discard_element?(:day)
          options[:start_year]      ||= nested_date_options(:year, :start, Time.now.year - 10)
          options[:end_year]        ||= nested_date_options(:year, :end, Time.now.year + 10)
          options[:use_month_names]   = nested_date_options(:month, :names, nil)
          options[:use_short_month]   = nested_date_options(:month, :short, false)
          options[:default]         ||= options.delete(:date) || nil
          options[:date_separator]    = options.delete(:separator) || " - "
          options[:include_blank]     = options.delete(:blank) || false
          super
        end
        
        def input
          builder.date_select(specific_method, options, html_options)
        end
        
        def discard_element?(type)
          case 
          when options.has_key?(type)
            (options[type] == false) ? true : false
          when options[:order].include?(type)
            false
          end
        end
        
        def nested_date_options(type, option, default)
          options.delete("#{option}_#{type}".to_sym) || (options[type].delete(option) if options[type].present?) || default
        end
    end
  end
end