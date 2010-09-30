# coding: utf-8
require 'test_helper'

class GeneratorHandleTest < ActionView::TestCase
  def generator_case_form_for(object, association, options={})
    concat(case_form_for(object) { |f| concat(f.new_object(association, options)) })
  end
  
  test "should generate generator" do
    generator_case_form_for(@user, :projects)
    assert_select "input[type=text]", 2
    assert_select "a[data-action=new]", 1
  end
  
  test "should generate generator with :text option" do
    text = "Dodaj"
    generator_case_form_for(@user, :projects, :text => text)
    assert_select "input[type=text]", 2
    assert_select "a[data-action=new]", text
  end
  
  test "should generate generator with :fields option" do
    generator_case_form_for(@user, :projects, :fields => :name)
    assert_select "input[type=text]", 1
    assert_select "a[data-action=new]", 1
  end
end