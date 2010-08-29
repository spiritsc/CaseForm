# coding: utf-8
require 'test_helper'

class StringInputTest < ActionView::TestCase
  def string_case_form_for(type = :string, options={})
    concat(case_form_for(@user) { |f| f.send(type, :firstname, options) })
  end
  
  test "should generate string input" do
    string_case_form_for(:string)
    assert_select "input[type=text]", 1
  end
  
  test "should generate email input" do
    string_case_form_for(:email)
    assert_select "input[type=email]", 1
  end
  
  test "should generate password input" do
    string_case_form_for(:password)
    assert_select "input[type=password]", 1
  end
  
  test "should generate telephone input" do
    string_case_form_for(:telephone)
    assert_select "input[type=tel]", 1
  end
  
  test "should generate url input" do
    string_case_form_for(:url)
    assert_select "input[type=url]", 1
  end
end