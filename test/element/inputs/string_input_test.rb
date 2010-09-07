# coding: utf-8
require 'test_helper'

class StringInputTest < ActionView::TestCase
  def string_case_form_for(object, method, attribute, options={})
    concat(case_form_for(object) { |f| f.send(method, attribute, options) })
  end
  
  test "should generate string input" do
    string_case_form_for(@user, :string, :firstname)
    assert_select "input[type=text]", 1
  end
  
  test "should generate email input" do
    string_case_form_for(@user, :email, :firstname)
    assert_select "input[type=email]", 1
  end
  
  test "should generate password input" do
    string_case_form_for(@user, :password, :firstname)
    assert_select "input[type=password]", 1
  end
  
  test "should generate telephone input" do
    string_case_form_for(@user, :telephone, :firstname)
    assert_select "input[type=tel]", 1
  end
  
  test "should generate url input" do
    string_case_form_for(@user, :url, :firstname)
    assert_select "input[type=url]", 1
  end
end