# coding: utf-8
require 'test_helper'

class HiddenInputTest < ActionView::TestCase
  def hidden_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.hidden(attribute, options) })
  end
  
  test "should generate hidden input" do
    hidden_case_form_for(@user, :firstname)
    assert_select "input[type=hidden]", 3 # +1 _utf and _method
  end
end