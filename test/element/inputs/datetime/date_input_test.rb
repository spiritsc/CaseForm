# coding: utf-8
require 'test_helper'

class DateInputTest < ActionView::TestCase
  def date_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.date(attribute, options) })
  end
  
  test "should generate date input" do
    date_case_form_for(@user, :created_at)
    assert_select "select", 3
    assert_select "select#user_created_at_1i", 1
    assert_select "select#user_created_at_2i", 1
    assert_select "select#user_created_at_3i", 1
  end
  
  test "should generate date input without year" do
    date_case_form_for(@user, :created_at, :year => false)
    assert_select "select", 2
    assert_select "input[type=hidden]#user_created_at_1i", 1
  end
  
  test "should generate date input without year in elements" do
    date_case_form_for(@user, :created_at, :elements => [:month, :day])
    assert_select "select", 2
    assert_select "input[type=hidden]#user_created_at_1i", 1
  end
  
  test "should generate date input without month" do
    date_case_form_for(@user, :created_at, :month => false)
    assert_select "select", 1 # no sense for only year and day
    assert_select "input[type=hidden]#user_created_at_2i", 1
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate date input without month in elements" do
    date_case_form_for(@user, :created_at, :elements => [:year, :day])
    assert_select "select", 1 # no sense for only year and day
    assert_select "input[type=hidden]#user_created_at_2i", 1
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate date input without day" do
    date_case_form_for(@user, :created_at, :day => false)
    assert_select "select", 2
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate date input without day in elements" do
    date_case_form_for(@user, :created_at, :elements => [:year, :month])
    assert_select "select", 2
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate date input with specific date" do
    date_case_form_for(@user, :created_at, :date => Date.tomorrow)
    assert_select("select#user_created_at_3i", 1) { assert_select "option[selected=selected]", :text => Date.tomorrow.day }
  end
  
  test "should generate date input with start and end year" do
    date_case_form_for(@user, :created_at, :year => {:start => 2008, :end => 2012 })
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate date input with :start_year and :end_year" do
    date_case_form_for(@user, :created_at, :start_year => 2008, :end_year => 2012)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate date input with mixed :start_year and end year" do
    date_case_form_for(@user, :created_at, :start_year => 2008, :year => { :end =>  2012 })
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate date input with :start_year rather than start year" do
    date_case_form_for(@user, :created_at, :start_year => 2008, :year => {:start => 2009}, :end_year => 2012)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate date input with :end_year rather than end year" do
    date_case_form_for(@user, :created_at, :end_year => 2012, :year => {:end => 2013}, :start_year => 2008)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate date input with long months" do
    date_case_form_for(@user, :created_at, :month => {:short => false})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "February" }
  end
  
  test "should generate date input with short months" do
    date_case_form_for(@user, :created_at, :month => {:short => true})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Feb" }
  end
  
  test "should generate date input without :short_month" do
    date_case_form_for(@user, :created_at, :short_month => false)
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "February" }
  end
  
  test "should generate date input with :short_month" do
    date_case_form_for(@user, :created_at, :short_month => true)
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Feb" }
  end
  
  test "should generate date input with month names" do
    date_case_form_for(@user, :created_at, :month => {:names => ["Styczownik", "Lutownik", "", "", "", "", "", "", "", "", "", ""]})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Lutownik" }
  end
  
  test "should generate date input with default month names when nil" do
    date_case_form_for(@user, :created_at, :month => {:names => nil})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "February" }
  end
  
  test "should generate date input without prompt" do
    date_case_form_for(@user, :created_at, :prompt => false)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", :count => 0, :text => "Year" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", :count => 0, :text => "Month" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", :count => 0, :text => "Day" }
  end
  
  test "should generate date input with default prompt" do
    date_case_form_for(@user, :created_at, :prompt => true)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", "Year" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Month" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", "Day" }
  end
  
  test "should generate date input with specific prompt" do
    date_case_form_for(@user, :created_at, :prompt => { :year => "Choose year", :month => "Choose month", :day => "Choose day"})
    assert_select("select#user_created_at_1i", 1) { assert_select "option", "Choose year" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Choose month" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", "Choose day" }
  end
  
  test "should generate date input with specific prompt as string" do
    text = "Choose date"
    date_case_form_for(@user, :created_at, :prompt => text)
    assert_select("select", 3) { assert_select "option", text }
  end
  
  test "should generate date input without blank" do
    date_case_form_for(@user, :created_at, :blank => false)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", :count => 0, :text => "" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", :count => 0, :text => "" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", :count => 0, :text => "" }
  end
  
  test "should generate date input with blank" do
    date_case_form_for(@user, :created_at, :blank => true)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", "" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", "" }
  end
  
  test "should generate date input as disabled" do
    date_case_form_for(@user, :created_at, :disabled => true)
    assert_select "select[disabled=disabled]", 3
  end
end