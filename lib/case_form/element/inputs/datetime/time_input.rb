# coding: utf-8
module CaseForm
  module Element
    class TimeInput < Input
      self.allowed_options -= [:id]
      self.allowed_options << [:placeholder, :readonly, :elements, :separator, :time, :default, 
                               :prompt, :minute_step, :date, :blank, :disabled]
      
      private
        def default_options
          options[:elements]        ||= [:hour, :minute]
          options[:time_separator]    = options.delete(:separator) || " : "
          options[:include_blank]     = options.delete(:blank) || false
          options[:include_seconds]   = time_seconds?
          options[:ignore_date]       = with_date?
          options[:default]         ||= options.delete(:time) || nil
          super
        end
        
        def input
          builder.time_select(specific_method, options, html_options)
        end
        
        def time_seconds?
          options[:elements].include?(:second) || false
        end
        
        def with_date?
          @date ||= options.delete(:date) || false
          !@date
        end
    end
  end
end