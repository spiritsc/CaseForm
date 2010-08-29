# coding: utf-8
require 'test_helper'

class TimeInputTest < ActionView::TestCase
  def time_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.time(attribute, options) })
  end
  
  test "should generate time input" do
    time_case_form_for(@user, :created_at)
    assert_select "select", 2 # for hour and minute 
  end
  
  test "should generate time without date" do
    time_case_form_for(@user, :created_at)
    assert_select "input[type=hidden]#user_created_at_1i", 0
    assert_select "input[type=hidden]#user_created_at_2i", 0
    assert_select "input[type=hidden]#user_created_at_3i", 0
  end
  
  test "should generate time with date" do
    time_case_form_for(@user, :created_at, :date => true)
    assert_select "input[type=hidden]#user_created_at_1i", 1
    assert_select "input[type=hidden]#user_created_at_2i", 1
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate time with different order" do
    time_case_form_for(@user, :created_at, :elements => [:second, :minute, :hour])
    assert_select "select", 3 # for hour, minute and second 
  end
  
  test "should generate time with own minute step" do
    time_case_form_for(@user, :created_at, :minute_step => 10)
    assert_select("select#user_created_at_5i") { assert_select "option", 6 }
  end
  
  test "should generate time with standard prompt" do
    time_case_form_for(@user, :created_at, :prompt => true)
    assert_select("select#user_created_at_4i") { assert_select "option", "Hour" }
    assert_select("select#user_created_at_5i") { assert_select "option", "Minute" }
  end
  
  test "should generate time with own prompt" do
    hour, minute = "Choose hour", "Choose minute"
    time_case_form_for(@user, :created_at, :prompt => { :hour => hour, :minute => minute })
    assert_select("select#user_created_at_4i") { assert_select "option", hour }
    assert_select("select#user_created_at_5i") { assert_select "option", minute }
  end
  
  test "should generate time with own text prompt" do
    text = "Choose time"
    time_case_form_for(@user, :created_at, :prompt => text)
    assert_select("select#user_created_at_4i") { assert_select "option", text }
    assert_select("select#user_created_at_5i") { assert_select "option", text }
  end
  
  test "should generate time without blank" do
    time_case_form_for(@user, :created_at, :blank => false)
    assert_select("select") { assert_select "option", :count => 0 , :text => "" }
  end
  
  test "should generate time with blank" do
    time_case_form_for(@user, :created_at, :blank => true)
    assert_select("select") { assert_select "option", "" }
  end
  
  test "should generate disabled time" do
    time_case_form_for(@user, :created_at, :disabled => true)
    assert_select "select[disabled=disabled]", 2
  end
end