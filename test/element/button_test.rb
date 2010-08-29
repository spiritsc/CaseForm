require 'test_helper'

class ButtonTest < ActionView::TestCase
  def buttons_case_form_for(*args)
    concat(case_form_for(@user) { |f| f.buttons(*args) })
  end
  
  test "should generate all buttons" do
    buttons_case_form_for
    assert_select "fieldset", 1
    assert_select "input", 3 # +1 _snowman
  end
  
  test "should generate buttons from args" do
    buttons_case_form_for(:commit, :reset)
    assert_select "fieldset", 1
    assert_select "input[type=submit]", 1
    assert_select "input[type=reset]", 1
  end
  
  test "should generate buttons from default config" do
    CaseForm.form_buttons = [:commit]
    buttons_case_form_for
    assert_select "fieldset", 1
    assert_select "input[type=submit]", 1
    assert_select "input[type=reset]", 0
  end
  
  def button_case_form_for(object, button_type, options={})
    concat(case_form_for(object) { |f| f.send(button_type, options) })
  end
  
  test "should generate button" do
    button_case_form_for(@user, :commit)
    assert_select "input[type=submit]", 1
  end
  
  test "should generate reset button" do
    button_case_form_for(@user, :reset)
    assert_select "input[type=reset]", 1
  end
  
  test "should generate button with text" do
    text = "Save"
    button_case_form_for(@user, :commit, :text => text)
    assert_select "input[value=#{text}]", 1
  end
  
  test "should generate button with default HTML class" do
    button_case_form_for(@user, :commit)
    assert_select "input.button", 1
  end
  
  test "should generate button with specific HTML class" do
    specific_class = :some_button_class
    button_case_form_for(@user, :commit, :class => specific_class)
    assert_select "input.#{specific_class}", 1
  end
  
  test "should generate button with default HTML id" do
    button_case_form_for(@user, :commit)
    assert_select "input#user_submit", 1
  end
  
  test "should generate button with specific HTML id" do
    specific_id = :some_button_id
    button_case_form_for(@user, :commit, :id => specific_id)
    assert_select "input##{specific_id}", 1
  end
  
  test "should generate button with non disabled options on default" do
    button_case_form_for(@user, :commit)
    assert_select "input[type=submit][disabled=disabled]", 0
  end
  
  test "should generate button with disabled options" do
    button_case_form_for(@user, :commit, :disabled => true)
    assert_select "input[type=submit][disabled=disabled]", 1
  end
  
  test "should generate button with wrong options" do
    assert_raise(ArgumentError) { button_case_form_for(@user, :commit, :foo => :bar) }
  end
end