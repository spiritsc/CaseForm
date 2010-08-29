# coding: utf-8
require 'test_helper'

class NumberInputTest < ActionView::TestCase
  def number_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.number(attribute, options) })
  end
  
  test "should generate number input" do
    number_case_form_for(@valid_user, :height)
    assert_select "input[type=number]", 1
  end
  
  test "should generate range input" do
    concat(case_form_for(@valid_user) { |f| f.range(:height) } )
    assert_select "input[type=range]", 1
  end
  
  test "should generate number input with min and max from column attribute" do
    number_case_form_for(@valid_user, :height)
    assert_select "input[type=number][min=-99.999][max=99.999]", 1
  end
  
  test "should generate number input with min and max from validation" do
    number_case_form_for(@valid_user, :valid_height)
    assert_select "input[type=number][min=0][max=280]", 1
  end
  
  test "should generate number input with min from validation" do
    number_case_form_for(@valid_user, :min_height)
    assert_select "input[type=number][min=0]", 1
    assert_select "input[type=number][max]", 0
  end
  
  test "should generate number input with max from validation" do
    number_case_form_for(@valid_user, :max_height)
    assert_select "input[type=number][min]", 0
    assert_select "input[type=number][max=280]", 1
  end
  
  test "should generate number input with step from column attribute" do
    number_case_form_for(@valid_user, :height)
    assert_select "input[type=number][step=0.001]", 1
  end
  
  test "should generate number input with default step from validation" do
    number_case_form_for(@valid_user, :valid_height)
    assert_select "input[type=number][step=1]", 1
  end
end