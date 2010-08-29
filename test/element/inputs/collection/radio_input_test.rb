# coding: utf-8
require 'test_helper'

class RadioInputTest < ActionView::TestCase
  def radio_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.radio(attribute, options) })
  end
  
  test "should generate radio input" do
    radio_case_form_for(@user, :admin)
    assert_input "input[type=radio]", 2
    assert_input "label", 3
  end
  
  test "should generate radio input with boolean attributes" do
    radio_case_form_for(@user, :admin)
    assert_input "label", "Admin"
    assert_input "input[type=radio][value=true]", 1
    assert_input "label", "Yes"
    assert_input "input[type=radio][value=false]", 1
    assert_input "label", "No"
  end
  
  test "should generate radio input with array collection" do
    collection = [['Adam', 1], ['John', 2], ['Martin', 3]]
    radio_case_form_for(@user, :description, :collection => collection)
    assert_input "label", "Description"
    collection.each do |c|
      assert_input "input[type=radio][value=#{c.last}]", 1
      assert_input "label", c.first
    end
  end
  
  test "should generate radio input with hash collection" do
    collection = { 'Adam' => 1, 'John' => 2, 'Martin' => 3 }
    radio_case_form_for(@user, :description, :collection => collection)
    assert_input "label", "Description"
    collection.each do |key, value|
      assert_input "input[type=radio][value=#{value}]", 1
      assert_input "label", key
    end
  end
  
  test "should generate radio input for belongs_to association" do
    radio_case_form_for(@user, :country)
    assert_input "label", "Country"
    assert_input "input[type=radio]", 5
    assert_input "label", 6
  end
  
  test "should generate radio input for belongs_to association and class name" do
    radio_case_form_for(@user, :country_id, :collection => Country)
    assert_input "label", "Country"
    assert_input "input[type=radio]", 5
    assert_input "label", 6
  end
  
  test "should generate radio input for belongs_to association with array collection" do
    radio_case_form_for(@user, :country, :collection => Country.all)
    assert_input "label", "Country"
    assert_input "input[type=radio]", 5
    assert_input "label", 6
  end
end