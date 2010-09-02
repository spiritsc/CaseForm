# coding: utf-8
require 'test_helper'

class RadioInputTest < ActionView::TestCase
  def radio_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.radio(attribute, options) })
  end
  
  test "should generate radio input" do
    radio_case_form_for(@user, :admin)
    assert_select "input[type=radio]", 2
    assert_select "label", 3
  end
  
  test "should generate radio input with boolean attributes" do
    radio_case_form_for(@user, :admin)
    assert_select "label", "Admin"
    assert_select "input[type=radio][value=true]", 1
    assert_select "label", "Yes"
    assert_select "input[type=radio][value=false]", 1
    assert_select "label", "No"
  end
  
  test "should generate radio input with array collection" do
    collection = [['Adam', 1], ['John', 2], ['Martin', 3]]
    radio_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |c|
      assert_select "input[type=radio][value=#{c.last}]", 1
      assert_select "label", c.first
    end
  end
  
  test "should generate radio input with flat array collection" do
    collection = ['Adam', 'John', 'Martin']
    radio_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |c|
      assert_select "input[type=radio][value='#{c}']", 1
      assert_select "label", c
    end
  end
  
  test "should generate radio input with hash collection" do
    collection = { 'Adam' => 1, 'John' => 2, 'Martin' => 3 }
    radio_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |label, value|
      assert_select "input[type=radio][value=#{value}]", 1
      assert_select "label", label
    end
  end
  
  test "should generate radio input with range collection" do
    collection = 1..5
    radio_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |value|
      assert_select "input[type=radio][value=#{value}]", 1
      assert_select "label", :text => value
    end
  end
  
  test "should generate radio input for :belongs_to association" do
    radio_case_form_for(@user, :country)
    assert_select "label", "Country"
    assert_select "input[type=radio][name='user[country_id]']", 5
    assert_select "label", 6
  end
  
  test "should generate radio input for :belongs_to association and class name" do
    radio_case_form_for(@user, :country, :collection => Country)
    assert_select "label", "Country"
    assert_select "input[type=radio][name='user[country_id]']", 5
    assert_select "label", 6
  end
  
  test "should generate radio input for :belongs_to association with array collection" do
    radio_case_form_for(@user, :country, :collection => Country.all)
    assert_select "label", "Country"
    assert_select "input[type=radio][name='user[country_id]']", 5
    assert_select "label", 6
  end
  
  test "should generate radio input for :belongs_to association with scoped array collection" do
    radio_case_form_for(@user, :country, :collection => Country.priority)
    assert_select "label", "Country"
    assert_select "input[type=radio][name='user[country_id]']", 3
    assert_select "label", 4
  end
  
  test "should generate radio input for :has_many association" do
    radio_case_form_for(@user, :projects)
    assert_select "label", "Projects"
    assert_select "input[type=radio][name='user[project_ids]']", 5
    assert_select "label", 6
  end
  
  test "should generate radio input for :has_many association and class name" do
    radio_case_form_for(@user, :projects, :collection => Project)
    assert_select "label", "Projects"
    assert_select "input[type=radio][name='user[project_ids]']", 5
    assert_select "label", 6
  end
  
  test "should generate radio input for :has_many association with array collection" do
    radio_case_form_for(@user, :projects, :collection => Project.all)
    assert_select "label", "Projects"
    assert_select "input[type=radio][name='user[project_ids]']", 5
    assert_select "label", 6
  end
  
  test "should generate radio input for :has_many association with scoped array collection" do
    radio_case_form_for(@user, :projects, :collection => Project.extra)
    assert_select "label", "Projects"
    assert_select "input[type=radio][name='user[project_ids]']", 3
    assert_select "label", 4
  end
  
  test "should generate radio input for association with specified label and value methods" do
    radio_case_form_for(@user, :country, :label_method => :short, :value_method => :id)
    assert_select "input[type=radio][name='user[country_id]']", 5
  end
  
  test "should generate radio input for association with specified label method" do
    radio_case_form_for(@user, :country, :label_method => :short)
    assert_select "input[type=radio][name='user[country_id]'][value=1]", 1 # "Poland" => 1
    assert_select "label", "Pol"
  end
  
  test "should generate radio input for association with specified value method" do
    radio_case_form_for(@user, :country, :value_method => :non_id)
    assert_select "input[type=radio][name='user[country_id]'][value=P]", 1 # "Poland" => 1
  end
  
  test "should generate radio input with checked value" do
    radio_case_form_for(@user, :country, :checked => 1)
    assert_select "input[type=radio][checked=checked]", 1
  end
  
  test "should generate radio input with selected value" do
    radio_case_form_for(@user, :country, :selected => 1)
    assert_select "input[type=radio][checked=checked]", 1
  end
  
  test "should generate radio input with disabled value" do
    radio_case_form_for(@user, :country, :disabled => [1, 2])
    assert_select "input[type=radio][disabled=disabled]", 2
  end
  
  test "should generate radio input with checked value as object value" do
    @user.country_id = 1
    radio_case_form_for(@user, :country)
    assert_select "input[type=radio][checked=checked]", :count => 1
  end
end