require 'test_helper'

class LabelTest < ActionView::TestCase
  def label_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.label(attribute, options) })
  end
  
  test "should generate label" do
    label_case_form_for(@user, :firstname)
    assert_select "label[for=user_firstname]"
  end
  
  test "should generate label with text" do
    label_case_form_for(@user, :firstname, :text => "Enter firstname")
    assert_select "label[for=user_firstname]", "Enter firstname"
  end
  
  test "should generate label with default HTML class" do
    label_case_form_for(@user, :firstname)
    assert_select "label[for=user_firstname].label"
  end
  
  test "should generate label with specific HTML class" do
    specific_class = "some_class"
    label_case_form_for(@user, :firstname, :class => specific_class)
    assert_select "label[for=user_firstname].#{specific_class}"
  end
  
  test "should generate label with default HTML id" do
    label_case_form_for(@user, :firstname)
    assert_select "label[for=user_firstname]#user_firstname_label"
  end
  
  test "should generate label with specific HTML id" do
    specific_id = "some_id"
    label_case_form_for(@user, :firstname, :id => specific_id)
    assert_select "label[for=user_firstname]##{specific_id}"
  end
  
  test "should generate label with wrong options" do
    assert_raise(ArgumentError) { label_case_form_for(@user, :firstname, :foo => :bar) }
  end
end