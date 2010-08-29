# coding: utf-8
require 'test_helper'

class SelectInputTest < ActionView::TestCase
  def select_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.select(attribute, options) })
  end
end