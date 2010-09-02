# coding: utf-8
require 'test_helper'

class SelectInputTest < ActionView::TestCase
  def select_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.select(attribute, options) })
  end
  
  test "should generate select input" do
    select_case_form_for(@user, :admin)
    assert_select "label", "Admin"
    assert_select "select", 1
  end
  
  test "should generate select input with default values" do
    select_case_form_for(@user, :admin)
    assert_select("select", 1) { assert_select "option", 3 }
  end
  
  test "should generate select input with array collection" do
    collection = [['Adam', 1], ['John', 2], ['Martin', 3]]
    select_case_form_for(@user, :description, :collection => collection)
    assert_select("select", 1) { collection.each { |c| assert_select "option[value=#{c.last}]", c.first } }
  end
  
  test "should generate select input with flat array collection" do
    collection = ['Adam', 'John', 'Martin']
    select_case_form_for(@user, :description, :collection => collection)
    assert_select("select", 1) { collection.each { |c| assert_select "option[value=#{c}]", c } }
  end
  
  test "should generate select input with hash collection" do
    collection = { 'Adam' => 1, 'John' => 2, 'Martin' => 3 }
    select_case_form_for(@user, :description, :collection => collection)
    assert_select("select", 1) { collection.each { |k, v| assert_select "option[value=#{v}]", k } }
  end
  
  test "should generate select input with range collection" do
    collection = 1..5
    select_case_form_for(@user, :description, :collection => collection)
    assert_select("select", 1) { collection.each { |c| assert_select "option[value=#{c}]", 1 } }
  end
  
  test "should generate select input for :belongs_to association" do
    select_case_form_for(@user, :country)
    assert_select "label", "Country"
    assert_select("select[name='user[country_id]']", 1) { assert_select "option", 6 }
  end
  
  test "should generate select input for :belongs_to association and class name" do
    select_case_form_for(@user, :country, :collection => Country)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option", 6 }
  end
  
  test "should generate select input for :belongs_to association with array collection" do
    select_case_form_for(@user, :country, :collection => Country.all)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option", 6 }
  end
  
  test "should generate select input for :belongs_to association with scoped array collection" do
    select_case_form_for(@user, :country, :collection => Country.priority)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option", 4 }
  end
  
  test "should generate select input for :has_many association" do
    select_case_form_for(@user, :projects)
    assert_select "label", "Projects"
    assert_select("select[name='user[project_ids][]']", 1) { assert_select "option", 6 }
  end
  
  test "should generate select input for :has_many association and class name" do
    select_case_form_for(@user, :projects, :collection => Project)
    assert_select("select[name='user[project_ids][]']", 1) { assert_select "option", 6 }
  end
  
  test "should generate select input for :has_many association with array collection" do
    select_case_form_for(@user, :projects, :collection => Project.all)
    assert_select("select[name='user[project_ids][]']", 1) { assert_select "option", 6 }
  end
  
  test "should generate select input for :has_many association with scoped array collection" do
    select_case_form_for(@user, :projects, :collection => Project.extra)
    assert_select("select[name='user[project_ids][]']", 1) { assert_select "option", 4 }
  end
  
  test "should generate select input for association with specified label and value methods" do
    select_case_form_for(@user, :country, :label_method => :short, :value_method => :id)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option[value=1]", "Pol" }
  end
  
  test "should generate select input for association with specified label method" do
    select_case_form_for(@user, :country, :label_method => :short)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option", "Pol" }
  end
  
  test "should generate select input for association with specified value method" do
    select_case_form_for(@user, :country, :value_method => :non_id)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option[value=P]", "Poland" }
  end
  
  test "should generate select input with checked value" do
    select_case_form_for(@user, :country, :checked => 1)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option[value=1][selected=selected]", 1 }
  end
  
  test "should generate select input with multiple checked value" do
    select_case_form_for(@user, :projects, :checked => [1, 3])
    assert_select("select[name='user[project_ids][]']", 1) { assert_select "option[selected=selected]", 2 }
  end
  
  test "should generate select input with selected value" do
    select_case_form_for(@user, :country, :selected => 1)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option[value=1][selected=selected]", 1 }
  end
  
  test "should generate select input with multiple selected value" do
    select_case_form_for(@user, :projects, :selected => [1, 3])
    assert_select("select[name='user[project_ids][]']", 1) { assert_select "option[selected=selected]", 2 }
  end
  
  test "should generate select input with disabled value" do
    select_case_form_for(@user, :country, :disabled => 1)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option[value=1][disabled=disabled]", 1 }
  end
  
  test "should generate select input with multiple disabled value" do
    select_case_form_for(@user, :projects, :disabled => [1, 3])
    assert_select("select[name='user[project_ids][]']", 1) { assert_select "option[disabled=disabled]", 2 }
  end
  
  test "should generate select input with checked value as object value" do
    @user.country_id = 1
    select_case_form_for(@user, :country)
    assert_select("select[name='user[country_id]']", 1) { assert_select "option[value=1][selected=selected]", 1 }
  end
  
  test "should generate select input with multiple option" do
    select_case_form_for(@user, :admin, :allow_multiple => true )
    assert_select("select[name='user[admin][]']", 1)
  end
  
  test "should generate select input without blank option" do
    select_case_form_for(@user, :admin, :blank => false )
    assert_select("select", 1) { assert_select "option[value='']", 0 }
  end
  
  test "should generate select input with prompt" do
    text = "Choose..."
    puts select_case_form_for(@user, :admin, :prompt => text )
    assert_select("select", 1) { assert_select "option", text }
  end
end