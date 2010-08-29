# coding: utf-8
module CaseForm
  module Element
    class TimeZoneInput < Input
      self.allowed_options << [:readonly, :blank, :disabled, 
                               :priority_zones, :zones, :time_zone]
      
      private
        def default_options
          options[:default]       = options.delete(:time_zone) || "UTC"
          options[:include_blank] = options.delete(:blank) || false
          super
        end
        
        def input
          builder.time_zone_select(specific_method, priority_zones, options, html_options)
        end
        
        def priority_zones
          options.delete(:priority_zones) || nil
        end
    end
  end
end