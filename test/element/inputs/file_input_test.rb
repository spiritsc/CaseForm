# coding: utf-8
require 'test_helper'

class FileInputTest < ActionView::TestCase
  def file_case_form_for(object, attribute, options={})
    concat(case_form_for(object) { |f| f.file(attribute, options) })
  end
  
  test "should generate file input" do
    file_case_form_for(@user, :firstname)
    assert_select "input[type=file]", 1
  end
end