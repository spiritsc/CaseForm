# coding: utf-8
require 'test_helper'

class SearchInputTest < ActionView::TestCase
  def text_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.text(attribute, options) })
  end
  
  test "should generate text input" do
    text_case_form_for(@user, :description)
    assert_select "textarea", 1
  end
end