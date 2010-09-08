# coding: utf-8
require 'test_helper'

class OneToOneAssociationTest < ActionView::TestCase
  test "should generate nasted inputs for :belongs_to association with block" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "input[type=text]", 1
  end
  
  test "should generate nasted inputs for :belongs_to association without block" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country) })
    assert_select "fieldset", 1
    assert_select "input[type=text]", 1
  end
  
  test "should generate input for :belongs_to association with :as and without block" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country, :as => :select) })
    assert_select "fieldset", 0
    assert_select "select", 1
  end
  
  test "should generate nasted inputs for :has_one association" do
    concat(case_form_for(@user) { |f| f.has_one(:profile) { |c| c.attribute(:email) } })
    assert_select "fieldset", 1
    assert_select "input[type=email]", 1
  end
  
  test "shouldn't generate input for :has_one association without block" do
    assert_raise(ArgumentError) { concat(case_form_for(@user) { |f| f.has_one(:country) }) }
  end
end