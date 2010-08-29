# coding: utf-8
require 'test_helper'

class SearchInputTest < ActionView::TestCase
  def search_case_form_for(options={})
    concat(case_form_for(@user) { |f| f.search(:firstname, options) })
  end
  
  test "should generate search input" do
    search_case_form_for
    assert_select "input[type=search]", 1
  end
end