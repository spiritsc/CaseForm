# coding: utf-8
require 'test_helper'

class AssociationTest < ActionView::TestCase
  test "should generate nasted inputs for association with block" do
    concat(case_form_for(@user) { |f| f.association(:country) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "input[type=text]", 1
  end
  
  test "should generate nasted inputs for association without block and defined :accept_*" do
    concat(case_form_for(@user) { |f| f.association(:country) })
    assert_select "fieldset", 1
    assert_select "input[type=text]", 1
  end
  
  test "should generate input for association with :as and without block" do
    concat(case_form_for(@user) { |f| f.association(:country, :as => :select) })
    assert_select "fieldset", 0
    assert_select "select", 1
  end
  
  test "shouldn generate nested inputs for association with :as and block" do
    concat(case_form_for(@user) { |f| f.association(:country, :as => :select) { |c| c.attribute :name } })
    assert_select "fieldset", 1
    assert_select "input[type=text]", 1
  end
  
  test "shouldn't generate nested inputs for association with block and not defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.association(:special_projects) { |c| c.attribute(:name) } }) }
  end
  
  test "shouldn't generate nested inputs for non association" do
    assert_raise(ArgumentError) { concat(case_form_for(@user) { |f| f.association(:firstname) { |c| c.attribute(:name) } }) }
  end
end