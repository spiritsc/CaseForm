# coding: utf-8
require 'test_helper'

class SearchInputTest < ActionView::TestCase
  def search_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.search(attribute, options) })
  end
  
  test "should generate search input" do
    search_case_form_for(@user, :firstname)
    assert_select "input[type=search]", 1
  end
end