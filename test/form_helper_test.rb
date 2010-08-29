require 'test_helper'

class FormHelperTest < ActionView::TestCase
  test "should exist case_form_for method" do
    assert ActionView::Helpers.method_defined?(:case_form_for)
  end
  
  test "should exist case_field_for method" do
    assert ActionView::Helpers.method_defined?(:case_fields_for)
  end
  
  test "should exist remote_case_form_for method" do
    assert ActionView::Helpers.method_defined?(:remote_case_form_for)
  end
end