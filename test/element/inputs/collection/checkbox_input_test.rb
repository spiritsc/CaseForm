# coding: utf-8
require 'test_helper'

class CheckboxInputTest < ActionView::TestCase
  def checkbox_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.checkbox(attribute, options) })
  end
  
  test "should generate checkbox input" do
    checkbox_case_form_for(@user, :admin)
    assert_select "input[type=checkbox]", 1
  end
  
  test "should generate checkbox input with default values" do
    checkbox_case_form_for(@user, :admin)
    assert_select "input[type=checkbox][value=true]", 1
  end
  
  test "should generate checkbox input with custom values as hash" do
    checkbox_case_form_for(@user, :admin, :collection => { :checked => 'yes', :unchecked => 'no' })
    assert_select "input[type=checkbox][value=yes]", 1
  end
  
  test "should generate checkbox input with custom values as array" do
    checkbox_case_form_for(@user, :admin, :collection => ['yes', 'no'] )
    assert_select "input[type=checkbox][value=yes]", 1
  end
  
  test "should generate checkbox input as checked" do
    @user.admin = false
    checkbox_case_form_for(@user, :admin, :checked => true )
    assert_select "input[type=checkbox][checked=checked]", 1
  end
  
  test "should generate checkbox input as not checked" do
    @user.admin = true
    checkbox_case_form_for(@user, :admin, :checked => false )
    assert_select "input[type=checkbox][checked=checked]", 0
  end
end