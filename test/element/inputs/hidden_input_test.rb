# coding: utf-8
require 'test_helper'

class HiddenInputTest < ActionView::TestCase
  def hidden_case_form_for(options={})
    concat(case_form_for(@user) { |f| f.hidden(:firstname, options) })
  end
  
  test "should generate hidden input" do
    hidden_case_form_for
    assert_select "input[type=hidden]", 2 # +1 _snowman
  end
end