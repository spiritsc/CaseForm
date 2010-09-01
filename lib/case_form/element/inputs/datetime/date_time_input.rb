# coding: utf-8
module CaseForm
  module Element
    class DateTimeInput < Input
      self.allowed_options -= [:id]
      self.allowed_options << [:placeholder, :readonly, :elements, :disabled,
                               :separator, :datetime_separator, :date_separator, :time_separator,
                               :year, :start_year, :end_year, :month, :short_month, :day, :hour, :minute, :second, 
                               :minute_step, :default, :datetime, :prompt, :blank]
                               
      private
        def default_options
          options[:elements]           ||= [:year, :month, :day, :hour, :minute]
          options[:order]                = options.delete(:elements)
          options[:discard_year]         = discard_element?(:year)
          options[:discard_month]        = discard_element?(:month)
          options[:discard_day]          = discard_element?(:day)
          options[:discard_hour]         = discard_element?(:hour)
          options[:discard_minute]       = discard_element?(:minute)
          options[:include_seconds]      = discard_element?(:second, false, true)
          options[:start_year]         ||= nested_date_options(:year, :start, Time.now.year - 10)
          options[:end_year]           ||= nested_date_options(:year, :end, Time.now.year + 10)
          options[:use_month_names]      = nested_date_options(:month, :names, nil)
          options[:use_short_month]      = nested_date_options(:month, :short, false)
          options[:minute_step]        ||= nested_date_options(:minute, :step, 1)
          options[:datetime_separator] ||= options.delete(:separator) || nil
          options[:default]            ||= options.delete(:datetime) || nil
          options[:include_blank]        = options.delete(:blank) || false
          super
        end
        
        def input
          builder.datetime_select(specific_method, options, html_options)
        end
        
        def discard_element?(type, t = true, f = false)
          case 
          when options.has_key?(type)
            (options[type] == false) ? t : f
          else 
            options[:order].include?(type) ? f : t
          end
        end
        
        def nested_date_options(type, option, default)
          options.delete("#{option}_#{type}".to_sym) || (options[type].delete(option) if options[type].present?) || default
        end
    end
  end
end