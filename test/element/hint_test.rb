require 'test_helper'

class HintTest < ActionView::TestCase
  setup do
    @tag = CaseForm.hint_tag = :span
    @text = "Your firstname"
  end
  
  def hint_form_for(method, options={})
    concat(case_form_for(@user) { |f| f.hint(method, options) })
  end
  
  test "should generate hint" do
    hint_form_for(:firstname, :text => @text)
    assert_select @tag.to_s, @text
  end
  
  test "should generate hint with string" do
    hint_form_for(@text)
    assert_select @tag.to_s, @text
  end
  
  test "should generate hint with symbol as attribute" do
    hint_form_for(:firstname)
    assert_select @tag.to_s, "translation missing: en, case_form, hints, user, firstname"
  end
  
  test "should generate hint with default HTML class" do
    hint_form_for(:firstname, :text => @text)
    assert_select @tag.to_s, :class => "hint"
  end
  
  test "should generate hint with specific HTML class" do
    specific_class = "some_class"
    hint_form_for(:firstname, :class => specific_class, :text => @text)
    assert_select @tag.to_s, :class => specific_class
  end
  
  test "should generate hint with default HTML id" do
    hint_form_for(:firstname, :text => @text)
    assert_select @tag.to_s, :id =>"user_firstname_hint"
  end
  
  test "should generate hint with specific HTML id" do
    specific_id = "some_id"
    hint_form_for(:firstname, :id => specific_id, :text => @text)
    assert_select @tag.to_s, :id => specific_id
  end
  
  test "should generate hint with specific tag" do
    specific_tag = CaseForm.hint_tag = "div"
    hint_form_for(:firstname, :text => @text)
    assert_select specific_tag, :id => "user_firstname_hint"
  end
  
  test "should generate hint with specific tag in options" do
    specific_tag = "div"
    hint_form_for(:firstname, :tag => specific_tag, :text => @text)
    assert_select specific_tag
  end
  
  test "should generate hint with multiple options" do
    specific_tag = "div"
    specific_id = "some_id"
    hint_form_for(:firstname, :tag => specific_tag, :id => specific_id)
    assert_select specific_tag, :id => specific_id
  end
  
  test "should generate hint with wrong options" do
    assert_raise(ArgumentError) { hint_form_for(:firstname, :foo => :bar) }
  end
end