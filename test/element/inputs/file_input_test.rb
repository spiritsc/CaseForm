# coding: utf-8
require 'test_helper'

class FileInputTest < ActionView::TestCase
  def file_case_form_for(options={})
    concat(case_form_for(@user) { |f| f.file(:firstname, options) })
  end
  
  test "should generate file input" do
    file_case_form_for
    assert_select "input[type=file]", 1
  end
end