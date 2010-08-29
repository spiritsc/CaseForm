require 'test_helper'

class FieldsetTest < ActionView::TestCase
  test "should generate fieldset for attributes" do
    concat(case_form_for(@user) { |f| f.attributes })
    assert_select "fieldset", :count => 1
  end
  
  test "should generate fieldset for buttons" do
    concat(case_form_for(@user) { |f| f.buttons })
    assert_select "fieldset", :count => 1
  end
  
  test "should generate fieldset with legend" do
    legend = "Actions"
    concat(case_form_for(@user) { |f| f.buttons(:text => legend) })
    assert_select "fieldset", :count => 1
    assert_select "legend", :count => 1, :text => legend
  end
end