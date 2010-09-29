# coding: utf-8
require 'test_helper'

class DestructorHandleTest < ActionView::TestCase
  def destructor_case_form_for(object, association, options={})
    concat(case_form_for(object) { |f| concat(f.association(association) { |d| d.destroy_object(options) }) })
  end
  
  test "should generate destructor" do
    destructor_case_form_for(@user, :projects)
    assert_select "fieldset", 1 # 2x Project object
    assert_select "input[type=checkbox]", 2
  end
  
  test "should generate destructor as link" do
    destructor_case_form_for(@user, :projects, :as => :link)
    assert_select "fieldset", 1 # 2x Project object
    assert_select "a[data-action=destroy]", 2
  end
  
  test "should generate destructor with text" do
    text = "Usun"
    destructor_case_form_for(@user, :projects, :text => text)
    assert_select "fieldset", 1 # 2x Project object
    assert_select "input[type=checkbox]", 2
    assert_select "label", :count => 2, :text => text
  end
  
  test "should generate destructor as link with text" do
    text = "Usun"
    destructor_case_form_for(@user, :projects, :as => :link, :text => text)
    assert_select "fieldset", 1 # 2x Project object
    assert_select "a[data-action=destroy]", :count => 2, :text => text
  end
end