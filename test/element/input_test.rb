# coding: utf-8
require 'test_helper'

class InputTest < ActionView::TestCase
  def input_case_form_for(object, input, attribute, options={})
    concat(case_form_for(object) { |f| f.send(input, attribute, options) })
  end
  
  test "should generate input" do
    input_case_form_for(@user, :string, :firstname)
    assert_select "input[type=text]", 1
  end
  
  test "should generate input without label" do
    input_case_form_for(@user, :string, :firstname, :label => false)
    assert_select "input[type=text]", 1
    assert_select "label", 0
  end
  
  test "should generate input with label" do
    text = "Some text"
    input_case_form_for(@user, :string, :firstname, :label => text)
    assert_select "input[type=text]", 1
    assert_select "label", text
  end
  
  test "should generate input with label options" do
    html_class = "super_html"
    input_case_form_for(@user, :string, :firstname, :label => { :class => html_class })
    assert_select "input[type=text]", 1
    assert_select "label.#{html_class}", 1
  end
  
  test "should generate input without error" do
    input_case_form_for(@user, :string, :firstname, :error => false)
    assert_select "input[type=text]", 1
    assert_select "#{cf_config(:error_tag)}#user_firstname_error", 0
  end
  
  test "should generate input with error" do
    input_case_form_for(@invalid_user, :string, :firstname)
    assert_select "input[type=text]", 1
    assert_select "#{cf_config(:error_tag)}#invalid_user_firstname_error", 1
  end
  
  test "should generate input with error options" do
    html_class = "super_html"
    input_case_form_for(@invalid_user, :string, :firstname, :error => { :class => html_class })
    assert_select "input[type=text]", 1
    assert_select "#{cf_config(:error_tag)}.#{html_class}", 1
  end
  
  test "should generate input without hint" do
    input_case_form_for(@user, :string, :firstname)
    assert_select "input[type=text]", 1
    assert_select "#{cf_config(:hint_tag)}#user_firstname_hint", 0
  end
  
  test "should generate input without hint in option" do
    input_case_form_for(@user, :string, :firstname, :hint => false)
    assert_select "input[type=text]", 1
    assert_select "#{cf_config(:hint_tag)}#user_firstname_hint", 0
  end
  
  test "should generate input with hint" do
    text = "Some hint"
    input_case_form_for(@user, :string, :firstname, :hint => text)
    assert_select "input[type=text]", 1
    assert_select "#{cf_config(:hint_tag)}#user_firstname_hint", text
  end
  
  test "should generate input with hint options" do
    html_class = "super_html"
    input_case_form_for(@user, :string, :firstname, :hint => { :class => html_class })
    assert_select "input[type=text]", 1
    assert_select "#{cf_config(:hint_tag)}#user_firstname_hint.#{html_class}", 1
  end
  
  test "should generate input with size options" do
    input_case_form_for(@user, :string, :firstname, :size => 55)
    assert_select "input[type=text][size=55]", 1
  end
  
  test "should generate input with defined type" do
    input_case_form_for(@user, :attribute, :firstname, :as => :string)
    assert_select "input[type=text]", 1
  end
  
  test "shouldn't generate input as bad input type" do
    assert_raise(ArgumentError) { input_case_form_for(@user, :attribute, :firstname, :as => :foo) }
  end
  
  test "should generate dynamic input as string" do
    input_case_form_for(@user, :attribute, :firstname)
    assert_select "input[type=text]", 1
  end
  
  test "should generate dynamic input as text" do
    input_case_form_for(@user, :attribute, :description)
    assert_select "textarea", 1
  end
  
  test "should generate dynamic input as number" do
    input_case_form_for(@user, :attribute, :age)
    assert_select "input[type=number]", 1
  end
  
  test "should generate dynamic input as datetime" do
    input_case_form_for(@user, :attribute, :created_at)
    assert_select "select", 5
  end
  
  test "should generate dynamic input as date" do
    input_case_form_for(@user, :attribute, :born_at)
    assert_select "select", 3
  end
  
  test "should generate dynamic input as time" do
    input_case_form_for(@user, :attribute, :login_at)
    assert_select "select", 2
  end
  
  test "should generate dynamic input as time zone" do
    input_case_form_for(@user, :attribute, :user_zone)
    assert_select "select", 1
  end
  
  test "should generate dynamic input as checkbox" do
    input_case_form_for(@user, :attribute, :admin)
    assert_select "input[type=checkbox]", 1
  end
  
  test "should generate dynamic input from name as password" do
    input_case_form_for(@user, :attribute, :password_confirmation)
    assert_select "input[type=password]", 1
  end
  
  test "should generate dynamic input from name as file" do
    input_case_form_for(@user, :attribute, :file_path)
    assert_select "input[type=file]", 1
  end
  
  test "should generate dynamic input from name as url" do
    input_case_form_for(@user, :attribute, :twitter_url)
    assert_select "input[type=url]", 1
  end
  
  test "should generate dynamic input from name as phone" do
    input_case_form_for(@user, :attribute, :mobile_phone)
    assert_select "input[type=tel]", 1
  end
  
  test "should generate input with invalid options" do
    assert_raise(ArgumentError) { input_case_form_for(@user, :attribute, :firstname, :foo => :bar) }
  end
  
  test "should generate input with custom data (HTML attribute)" do
    input_case_form_for(@user, :attribute, :firstname, :custom => { :foo => :bar })
    assert_select "input[type=text][data-foo=bar]", 1
  end
  
  test "should generate input with invalid custom data (HTML attribute)" do
    assert_raise(ArgumentError) { input_case_form_for(@user, :attribute, :firstname, :custom => :foo) }
  end
  
  test "should generate input as required" do
    input_case_form_for(@user, :string, :firstname, :required => true)
    assert_select "input[type=text][required=required]", 1
    assert_select "label", "Firstname*"
  end
  
  test "should generate input as not required" do
    input_case_form_for(@user, :string, :firstname, :required => false)
    assert_select "input[type=text][required=required]", 0
    assert_select "label", "Firstname"
  end
  
  test "should generate input as required from validation" do
    input_case_form_for(@valid_user, :string, :firstname)
    assert_select "input[type=text][required=required]", 1
    assert_select "label", "Firstname*"
  end
  
  test "should generate input as required from column NULL" do
    input_case_form_for(@user, :string, :lastname)
    assert_select "input[type=text][required=required]", 1
    assert_select "label", "Lastname*"
  end
  
  test "should generate input as required from config" do
    CaseForm.all_fields_required = true
    input_case_form_for(@user, :string, :firstname)
    CaseForm.all_fields_required = false
    assert_select "input[type=text][required=required]", 1
    assert_select "label", "Firstname*"
  end
end