require 'test_helper'

class SimpleErrorTest < ActionView::TestCase
  setup do
    CaseForm.error_tag = :div
  end
  
  def error_case_form_for(method, options={})
    concat(case_form_for(@invalid_user) { |f| concat(f.error method, options) })
  end
  
  test "should generate standard error" do
    error_case_form_for(:firstname)
    assert_select "div.error", 1
  end
  
  test "shouldn't generate standard error for valid object" do
    concat(case_form_for(@user) { |f| concat(f.error :firstname) })
    assert_select "div.error", 0 # No error :div
  end
  
  test "should generate standard error as sentence in config" do
    CaseForm.error_type = :sentence
    error_case_form_for(:firstname)
    assert_select "div.error"
  end
  
  test "should generate standard error as sentence in options" do
    error_case_form_for(:firstname, :as => :sentence)
    assert_select "div.error"
  end
  
  test "should generate standard error as list in config" do
    CaseForm.error_type = :list
    error_case_form_for(:firstname)
    assert_select "div.error ul li"
  end
    
  test "should generate standard error as list in options" do
    error_case_form_for(:firstname, :as => :list)
    assert_select "div.error ul li"
  end
  
  test "should generate standard error with default connectors" do
    error_case_form_for(:firstname, :as => :sentence)
    assert_select "div.error", /,/
  end
  
  test "should generate standard error with special connectors" do
    error_case_form_for(:firstname, :as => :sentence, :connector => " + ", :last_connector => " AND ")
    assert_select "div.error", /\+/
    assert_select "div.error", /AND/
  end
    
  test "should generate standard error with default HTML class" do
    error_case_form_for(:firstname)
    assert_select "div.error"
  end
  
  test "should generate standard error with specific HTML class" do
    specific_class = "some_class"
    error_case_form_for(:firstname, :class => specific_class)
    assert_select "div.#{specific_class}"
  end
  
  test "should generate standard error with default HTML id" do
    error_case_form_for(:firstname)
    assert_select "div#invalid_user_firstname_error"
  end
  
  test "should generate standard error with specific HTML id" do
    specific_id = "some_id"
    error_case_form_for(:firstname, :id => specific_id)
    assert_select "div##{specific_id}"
  end
  
  test "should generate standard error with specific tag" do
    specific_tag = CaseForm.error_tag = "span"
    error_case_form_for(:firstname)
    assert_select specific_tag
  end
  
  test "should generate standard error with specific tag in options" do
    specific_tag = "span"
    error_case_form_for(:firstname, :tag => specific_tag)
    assert_select specific_tag
  end
  
  test "should generate hint with wrong options" do
    assert_raise(ArgumentError) { error_case_form_for(:firstname, :foo => :bar) }
  end
end