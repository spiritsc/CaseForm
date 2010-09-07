require 'test_helper'

class FieldsetTest < ActionView::TestCase
  def fieldset_case_form_for(object, method, options={})
    concat(case_form_for(object) { |f| f.send(method, options) })
  end
  
  def fieldset_case_fields_for(object, method, attribute, options={})
    concat(case_form_for(object) { |f| f.send(method, attribute, options) })
  end
  
  test "should generate fieldset for attributes" do
    fieldset_case_form_for(@user, :attributes)
    assert_select "fieldset", :count => 1
  end
  
  test "should generate fieldset for buttons" do
    fieldset_case_form_for(@user, :buttons)
    assert_select "fieldset", :count => 1
  end
  
  test "should generate fieldset with legend" do
    legend = "Actions"
    fieldset_case_form_for(@user, :attributes, :text => legend)
    assert_select "fieldset", :count => 1
    assert_select "legend", :count => 1, :text => legend
  end
  
  test "should generate fieldset for :case_fields_for and :belongs_to association" do
    concat(case_form_for(@user) { |f| f.case_fields_for(:country, @user.country) { |p| p.attribute(:name) } })
    assert_select "fieldset", 1
  end
  
  test "should generate fieldset for :belongs_to association" do
    concat(case_form_for(@user) { |f| f.association(:country, @user.country) { |p| p.attribute(:name) } })
    assert_select "fieldset", 1
  end
  
  test "should generate fieldset for :case_fields_for and :has_one association" do
    concat(case_form_for(@user) { |f| f.case_fields_for(:profile, @user.profile) { |p| p.attribute(:email) } })
    assert_select "fieldset", 1
  end
  
  test "should generate fieldset for :has_one association" do
    concat(case_form_for(@user) { |f| f.association(:profile, @user.profile) { |p| p.email(:email) } })
    assert_select "fieldset", 1
  end
  
  test "shouldn't generate fieldset and raise for :has_one association without block" do
    assert_raise(ArgumentError) { concat(case_form_for(@user) { |f| f.association(:profile, @user.profile) }) }
  end
  
  test "should generate fieldset for :case_fields_for and :has_many association" do
    concat(case_form_for(@user) { |f| f.case_fields_for(:projects, @user.projects) { |p| p.attribute(:name) } })
    assert_select "fieldset", 1
  end
  
  test "should generate fieldset for :has_many association" do
    concat(case_form_for(@user) { |f| f.association(:projects, @user.projects) { |p| p.attribute(:name) } })
    assert_select "fieldset", 1
  end
end