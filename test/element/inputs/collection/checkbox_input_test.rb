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
  
  test "should generate checkbox input with boolean attributes" do
    checkbox_case_form_for(@user, :admin)
    assert_select "label", "Admin"
    assert_select "input[type=checkbox][value=true]", 1
    assert_select "label", "Yes"
    assert_select "input[type=hidden][value='']", 1
  end
  
  test "should generate checkbox input with array collection" do
    collection = [['Adam', 1], ['John', 2], ['Martin', 3]]
    checkbox_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |c|
      assert_select "input[type=checkbox][value=#{c.last}]", 1
      assert_select "label", c.first
    end
  end
  
  test "should generate checkbox input with flat array collection" do
    collection = ['Adam', 'John', 'Martin']
    checkbox_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |c|
      assert_select "input[type=checkbox][value='#{c}']", 1
      assert_select "label", c
    end
  end
  
  test "should generate checkbox input with hash collection" do
    collection = { 'Adam' => 1, 'John' => 2, 'Martin' => 3 }
    checkbox_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |label, value|
      assert_select "input[type=checkbox][value=#{value}]", 1
      assert_select "label", label
    end
  end
  
  test "should generate checkbox input with range collection" do
    collection = 1..5
    checkbox_case_form_for(@user, :description, :collection => collection)
    assert_select "label", "Description"
    collection.each do |value|
      assert_select "input[type=checkbox][value=#{value}]", 1
      assert_select "label", :text => value
    end
  end
  
  test "should generate checkbox input for :belongs_to association" do
    checkbox_case_form_for(@user, :country)
    assert_select "label", "Country"
    assert_select "input[type=checkbox][name='user[country_id]']", 5
    assert_select "label", 6
  end
  
  test "should generate checkbox input for :belongs_to association and class name" do
    checkbox_case_form_for(@user, :country, :collection => Country)
    assert_select "label", "Country"
    assert_select "input[type=checkbox][name='user[country_id]']", 5
    assert_select "label", 6
  end
  
  test "should generate checkbox input for :belongs_to association with array collection" do
    checkbox_case_form_for(@user, :country, :collection => Country.all)
    assert_select "label", "Country"
    assert_select "input[type=checkbox][name='user[country_id]']", 5
    assert_select "label", 6
  end
  
  test "should generate checkbox input for :belongs_to association with scoped array collection" do
    checkbox_case_form_for(@user, :country, :collection => Country.priority)
    assert_select "label", "Country"
    assert_select "input[type=checkbox][name='user[country_id]']", 3
    assert_select "label", 4
  end
  
  test "should generate checkbox input for :has_many association" do
    checkbox_case_form_for(@user, :projects)
    assert_select "label", "Projects"
    assert_select "input[type=checkbox][name='user[project_ids][]']", 5
    assert_select "label", 6
  end
  
  test "should generate checkbox input for :has_many association and class name" do
    checkbox_case_form_for(@user, :projects, :collection => Project)
    assert_select "label", "Projects"
    assert_select "input[type=checkbox][name='user[project_ids][]']", 5
    assert_select "label", 6
  end
  
  test "should generate checkbox input for :has_many association with array collection" do
    checkbox_case_form_for(@user, :projects, :collection => Project.all)
    assert_select "label", "Projects"
    assert_select "input[type=checkbox][name='user[project_ids][]']", 5
    assert_select "label", 6
  end
  
  test "should generate checkbox input for :has_many association with scoped array collection" do
    checkbox_case_form_for(@user, :projects, :collection => Project.extra)
    assert_select "label", "Projects"
    assert_select "input[type=checkbox][name='user[project_ids][]']", 3
    assert_select "label", 4
  end
  
  test "should generate checkbox input for association with specified label and value methods" do
    checkbox_case_form_for(@user, :country, :label_method => :short, :value_method => :id)
    assert_select "input[type=checkbox][name='user[country_id]']", 5
  end
  
  test "should generate checkbox input for association with specified label method" do
    checkbox_case_form_for(@user, :country, :label_method => :short)
    assert_select "input[type=checkbox][name='user[country_id]'][value=1]", 1 # "Poland" => 1
    assert_select "label", "Pol"
  end
  
  test "should generate checkbox input for association with specified value method" do
    checkbox_case_form_for(@user, :country, :value_method => :non_id)
    assert_select "input[type=checkbox][name='user[country_id]'][value=P]", 1 # "Poland" => 1
  end
  
  test "should generate checkbox input with checked value" do
    checkbox_case_form_for(@user, :country, :checked => 1)
    assert_select "input[type=checkbox][checked=checked]", 1
  end
  
  test "should generate checkbox input with selected value" do
    checkbox_case_form_for(@user, :country, :selected => 1)
    assert_select "input[type=checkbox][checked=checked]", 1
  end
  
  test "should generate checkbox input with disabled value" do
    checkbox_case_form_for(@user, :country, :disabled => [1, 2])
    assert_select "input[type=checkbox][disabled=disabled]", 2
  end
  
  test "should generate checkbox input with checked value as object value" do
    @user.country_id = 1
    checkbox_case_form_for(@user, :country)
    assert_select "input[type=checkbox][checked=checked]", :count => 1
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
  
  test "should generate checkbox input with multiple option" do
    checkbox_case_form_for(@user, :admin, :allow_multiple => true )
    assert_select "input[type=checkbox][name='user[admin][]']", 1
  end
end