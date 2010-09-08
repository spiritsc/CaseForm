# coding: utf-8
require 'test_helper'

class CollectionAssociationTest < ActionView::TestCase
  test "should generate nested inputs for :has_many association with block" do
    concat(case_form_for(@user) { |f| f.has_many(:projects) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "input[type=text]", 2
  end
  
  test "should generate nested inputs for :has_many association without block" do
    concat(case_form_for(@user) { |f| f.has_many(:projects) })
    assert_select "fieldset", 1
    assert_select "input[type=text]", 4 # (2x name and address)
  end
  
  test "should generate input for :has_many association with :as option" do
    concat(case_form_for(@user) { |f| f.has_many(:projects, :as => :checkbox) })
    assert_select "fieldset", 0
    assert_select "input[type=checkbox]", 5
  end
end