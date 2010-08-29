# coding: utf-8
require 'test_helper'

class SearchInputTest < ActionView::TestCase
  def text_case_form_for(options={})
    concat(case_form_for(@user) { |f| f.text(:firstname, options) })
  end
  
  test "should generate text input" do
    text_case_form_for
    assert_select "textarea", 1
  end
end