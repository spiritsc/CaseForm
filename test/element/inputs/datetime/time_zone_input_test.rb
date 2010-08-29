# coding: utf-8
require 'test_helper'

class TimeZoneInputTest < ActionView::TestCase
  def time_zone_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.time_zone(attribute, options) })
  end
  
  test "should generate time zone input" do
    time_zone_case_form_for(@user, :firstname)
    assert_select "select", 1
  end
  
  test "should generate time zone without blank" do
    time_zone_case_form_for(@user, :firstname, :blank => false)
    assert_select("select") { assert_select "option", :count => 0 , :text => "" }
  end
  
  test "should generate time zone with blank" do
    time_zone_case_form_for(@user, :firstname, :blank => true)
    assert_select("select") { assert_select "option", :count => 1 , :text => "" }
  end
  
  # TODO fixit
  # test "should generate time zone with selected zone" do
  #   zone = "Warsaw"
  #   time_zone_case_form_for(@user, :firstname, :time_zone => zone)
  #   assert_select("select") { assert_select "option[selected=selected]", 1 }
  # end
  
  test "should generate time zone with priority zones" do
    zones = [::ActiveSupport::TimeZone['Warsaw'], ::ActiveSupport::TimeZone['London']]
    time_zone_case_form_for(@user, :firstname, :priority_zones => zones)
    assert_select("select") { assert_select "option[disabled=disabled]", 1 }
  end
  
  test "should generate time zone with html class" do
    html_class = "Warsaw"
    time_zone_case_form_for(@user, :firstname, :class => html_class)
    assert_select("select.#{html_class}")
  end
end