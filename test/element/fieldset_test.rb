require 'test_helper'

class FieldsetTest < ActionView::TestCase
  def fieldset_case_form_for(object, method, options={})
    concat(case_form_for(object) { |f| f.send(method, options) })
  end
  
  def fieldset_case_fields_for(object, method, attribute, options={})
    concat(case_form_for(object) { |f| f.send(method, attribute, options) })
  end
  
  test "should generate fieldset for attributes" do
    fieldset_case_form_for(@user, :attributes)
    assert_select "fieldset", :count => 1
  end
  
  test "should generate fieldset for buttons" do
    fieldset_case_form_for(@user, :buttons)
    assert_select "fieldset", :count => 1
  end
  
  test "should generate fieldset with legend" do
    legend = "Actions"
    fieldset_case_form_for(@user, :attributes, :text => legend)
    assert_select "fieldset", :count => 1
    assert_select "legend", :count => 1, :text => legend
  end
end