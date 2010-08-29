# coding: utf-8
module CaseForm
  module LayoutHelper
    def case_form_stylesheet_link_tag
      stylesheet_link_tag("case_form")
    end
    alias_method :case_form_stylesheet, :case_form_stylesheet_link_tag
    
    def case_form_javascript_include_tag
      # TODO
    end
    alias_method :case_form_js, :case_form_javascript_include_tag
  end
end

