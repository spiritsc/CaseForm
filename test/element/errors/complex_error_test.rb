require 'test_helper'

class ComplexErrorTest < ActionView::TestCase
  setup do
    CaseForm.error_tag = :div
    CaseForm.complex_error_header_tag = :h2
    CaseForm.complex_error_message_tag = :p
  end
  
  def errors_case_form_for(options={})
    concat(case_form_for(@invalid_user) { |f| concat(f.errors options) })
  end
  
  test "should generate complex error" do
    errors_case_form_for
    assert_select "div.errors", 1
    assert_select "h2", 1
    assert_select "p", 1
    assert_select "ul", 1
  end
  
  test "shouldn't generate complex error for valid object" do
    concat(case_form_for(@user) { |f| concat(f.errors) })
    assert_select "div.errors", 0 # No error :div
  end
  
  test "should generate complex error as sentance in config" do
    CaseForm.error_type = :sentence
    errors_case_form_for
    assert_select "div.errors", 1
    assert_select "ul", 1
    assert_select "li", 3
  end
  
  test "should generate complex error as sentance in options" do
    errors_case_form_for(:as => :sentence)
    assert_select "div.errors", 1
    assert_select "ul", 1
    assert_select "li", 3
  end
  
  test "should generate complex error as list in config" do
    CaseForm.error_type = :list
    errors_case_form_for
    assert_select "div.errors", 1
    assert_select "ul", 1
    assert_select "li", 5
  end
    
  test "should generate complex error as list in options" do
    errors_case_form_for(:as => :list)
    assert_select "div.errors", 1
    assert_select "ul", 1
    assert_select "li", 5
  end
  
  test "should generate complex error with default connectors" do
    errors_case_form_for(:as => :sentance)
    assert_select "li", /,/
    assert_select "li", /and/
  end
  
  test "should generate complex error with special connectors" do
    errors_case_form_for(:as => :sentance, :connector => " + ", :last_connector => " AND ")
    assert_select "li", /\+/
    assert_select "li", /AND/
  end
    
  test "should generate complex error with default HTML class" do
    errors_case_form_for
    assert_select "div.errors", 1
  end
  
  test "should generate complex error with specific HTML class" do
    specific_class = "some_class"
    errors_case_form_for(:class => specific_class)
    assert_select "div.#{specific_class}", 1
  end
  
  test "should generate complex error with default HTML id" do
    errors_case_form_for
    assert_select "div#invalid_user_errors", 1
  end
  
  test "should generate complex error with specific HTML id" do
    specific_id = "some_id"
    errors_case_form_for(:id => specific_id)
    assert_select "div##{specific_id}", 1
  end
  
  test "should generate complex error with specific tag" do
    specific_tag = CaseForm.error_tag = "span"
    errors_case_form_for
    assert_select specific_tag
  end
  
  test "should generate complex error with specific tag in options" do
    specific_tag = "span"
    errors_case_form_for(:tag => specific_tag)
    assert_select specific_tag
  end
  
  test "should generate complex error with specific header tag" do
    specific_tag = CaseForm.complex_error_header_tag = "h4"
    errors_case_form_for
    assert_select specific_tag
  end
  
  test "should generate complex error with specific header tag in options" do
    specific_tag = "h4"
    errors_case_form_for(:header_tag => specific_tag)
    assert_select specific_tag
  end
  
  test "should generate complex error with specific message tag" do
    specific_tag = CaseForm.complex_error_message_tag = "pre"
    errors_case_form_for
    assert_select specific_tag
  end
  
  test "should generate complex error with specific message tag in options" do
    specific_tag = "h4"
    errors_case_form_for(:message_tag => specific_tag)
    assert_select specific_tag
  end
  
  test "should generate hint with wrong options" do
    assert_raise(ArgumentError) { errors_case_form_for(:foo => :bar) }
  end
end