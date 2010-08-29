# coding: utf-8
require 'test_helper'

class DateTimeInputTest < ActionView::TestCase
  def datetime_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.datetime(attribute, options) })
  end
  
  test "should generate datetime input" do
    datetime_case_form_for(@user, :created_at)
    assert_select "select", 5
    assert_select "select#user_created_at_1i", 1
    assert_select "select#user_created_at_2i", 1
    assert_select "select#user_created_at_3i", 1
    assert_select "select#user_created_at_4i", 1
    assert_select "select#user_created_at_5i", 1
  end
  
  test "should generate datetime input without year" do
    datetime_case_form_for(@user, :created_at, :year => false)
    assert_select "select", 4
    assert_select "input[type=hidden]#user_created_at_1i", 1
  end
  
  test "should generate datetime input without year in elements" do
    datetime_case_form_for(@user, :created_at, :elements => [:month, :day, :hour, :minute, :second])
    assert_select "select", 5
    assert_select "input[type=hidden]#user_created_at_1i", 1
  end
  
  test "should generate datetime input without month" do
    datetime_case_form_for(@user, :created_at, :month => false)
    assert_select "select", 3 # no sense for only year and day
    assert_select "input[type=hidden]#user_created_at_2i", 1
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate datetime input without month in elements" do
    datetime_case_form_for(@user, :created_at, :elements => [:year, :day, :hour, :minute, :second])
    assert_select "select", 4 # no sense for only year and day
    assert_select "input[type=hidden]#user_created_at_2i", 1
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate datetime input without day" do
    datetime_case_form_for(@user, :created_at, :day => false)
    assert_select "select", 4
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate datetime input without day in elements" do
    datetime_case_form_for(@user, :created_at, :elements => [:year, :month, :hour, :minute, :second])
    assert_select "select", 5
    assert_select "input[type=hidden]#user_created_at_3i", 1
  end
  
  test "should generate datetime input without hour" do
    datetime_case_form_for(@user, :created_at, :hour => false)
    assert_select "select", 3 # no sense for time without hour (delete all time fields)
  end
  
  test "should generate datetime input without hour in elements" do
    datetime_case_form_for(@user, :created_at, :elements => [:year, :month, :day, :minute, :second])
    assert_select "select", 3 # no sense for time without hour (delete all time fields)
  end
  
  test "should generate datetime input without minute" do
    datetime_case_form_for(@user, :created_at, :minute => false)
    assert_select "select", 4
    assert_select "input[type=hidden]#user_created_at_5i", 1
  end
  
  test "should generate datetime input without minute in elements" do
    datetime_case_form_for(@user, :created_at, :elements => [:year, :month, :day, :hour, :second])
    assert_select "select", 4 # no sense for second without minute (delete minute and second time fields)
    assert_select "input[type=hidden]#user_created_at_5i", 1
  end
  
  test "should generate datetime input with second" do
    datetime_case_form_for(@user, :created_at, :second => true)
    assert_select "select", 6
  end
  
  test "should generate datetime input without second" do
    datetime_case_form_for(@user, :created_at, :second => false)
    assert_select "select", 5
    assert_select "input[type=hidden]#user_created_at_6i", 0
  end
  
  test "should generate datetime input with second in elements" do
    datetime_case_form_for(@user, :created_at, :elements => [:year, :month, :day, :hour, :minute, :second])
    assert_select "select", 6
  end
  
  test "should generate datetime input without second in elements" do
    datetime_case_form_for(@user, :created_at, :elements => [:year, :month, :day, :hour, :minute])
    assert_select "select", 5
    assert_select "input[type=hidden]#user_created_at_6i", 0
  end
  
  test "should generate datetime input with specific datetime" do
    datetime = Time.now + 86400
    datetime_case_form_for(@user, :created_at, :datetime => datetime)
    assert_select("select#user_created_at_3i", 1) { assert_select "option[selected=selected]", :text => (Time.now.day + 1) }
  end
  
  test "should generate datetime input with start and end year" do
    datetime_case_form_for(@user, :created_at, :year => {:start => 2008, :end => 2012 })
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate datetime input with :start_year and :end_year" do
    datetime_case_form_for(@user, :created_at, :start_year => 2008, :end_year => 2012)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate datetime input with mixed :start_year and end year" do
    datetime_case_form_for(@user, :created_at, :start_year => 2008, :year => { :end =>  2012 })
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate datetime input with :start_year rather than start year" do
    datetime_case_form_for(@user, :created_at, :start_year => 2008, :year => {:start => 2009}, :end_year => 2012)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate datetime input with :end_year rather than end year" do
    datetime_case_form_for(@user, :created_at, :end_year => 2012, :year => {:end => 2013}, :start_year => 2008)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", 5 }
  end
  
  test "should generate datetime input with long months" do
    datetime_case_form_for(@user, :created_at, :month => {:short => false})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "February" }
  end
  
  test "should generate datetime input with short months" do
    datetime_case_form_for(@user, :created_at, :month => {:short => true})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Feb" }
  end
  
  test "should generate datetime input without :short_month" do
    datetime_case_form_for(@user, :created_at, :short_month => false)
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "February" }
  end
  
  test "should generate datetime input with :short_month" do
    datetime_case_form_for(@user, :created_at, :short_month => true)
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Feb" }
  end
  
  test "should generate datetime input with month names" do
    datetime_case_form_for(@user, :created_at, :month => {:names => ["Styczownik", "Lutownik", "", "", "", "", "", "", "", "", "", ""]})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Lutownik" }
  end
  
  test "should generate datetime input with default month names when nil" do
    datetime_case_form_for(@user, :created_at, :month => {:names => nil})
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "February" }
  end
  
  test "should generate datetime input without prompt" do
    datetime_case_form_for(@user, :created_at, :prompt => false)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", :count => 0, :text => "Year" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", :count => 0, :text => "Month" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", :count => 0, :text => "Day" }
    assert_select("select#user_created_at_4i", 1) { assert_select "option", :count => 0, :text => "Hour" }
    assert_select("select#user_created_at_5i", 1) { assert_select "option", :count => 0, :text => "Minute" }
  end
  
  test "should generate datetime input with default prompt" do
    datetime_case_form_for(@user, :created_at, :prompt => true)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", "Year" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Month" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", "Day" }
    assert_select("select#user_created_at_4i", 1) { assert_select "option", "Hour" }
    assert_select("select#user_created_at_5i", 1) { assert_select "option", "Minute" }
  end
  
  test "should generate datetime input with specific prompt" do
    datetime_case_form_for(@user, :created_at, :prompt => { :year => "Choose year", :month => "Choose month", :day => "Choose day", :hour => "Choose hour", :minute => "Choose minute"})
    assert_select("select#user_created_at_1i", 1) { assert_select "option", "Choose year" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "Choose month" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", "Choose day" }
    assert_select("select#user_created_at_4i", 1) { assert_select "option", "Choose hour" }
    assert_select("select#user_created_at_5i", 1) { assert_select "option", "Choose minute" }
  end
  
  test "should generate datetime input with specific prompt as string" do
    text = "Choose date and time"
    datetime_case_form_for(@user, :created_at, :prompt => text)
    assert_select("select", 5) { assert_select "option", text }
  end
  
  test "should generate datetime input without blank" do
    datetime_case_form_for(@user, :created_at, :blank => false)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", :count => 0, :text => "" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", :count => 0, :text => "" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", :count => 0, :text => "" }
    assert_select("select#user_created_at_4i", 1) { assert_select "option", :count => 0, :text => "" }
    assert_select("select#user_created_at_5i", 1) { assert_select "option", :count => 0, :text => "" }
  end
  
  test "should generate datetime input with blank" do
    datetime_case_form_for(@user, :created_at, :blank => true)
    assert_select("select#user_created_at_1i", 1) { assert_select "option", "" }
    assert_select("select#user_created_at_2i", 1) { assert_select "option", "" }
    assert_select("select#user_created_at_3i", 1) { assert_select "option", "" }
    assert_select("select#user_created_at_4i", 1) { assert_select "option", "" }
    assert_select("select#user_created_at_5i", 1) { assert_select "option", "" }
  end
  
  test "should generate datetime input as disabled" do
    datetime_case_form_for(@user, :created_at, :disabled => true)
    assert_select "select[disabled=disabled]", 5
  end
end