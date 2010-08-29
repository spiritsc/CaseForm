require 'test_helper'

class FormBuilderTest < ActionView::TestCase
  test 'should case_form_for be an instance of CaseForm::FormBuilder' do
    case_form_for(@user) { |f| assert f.instance_of?(CaseForm::FormBuilder) }
  end
  
  test 'should case_fields_for be an instance of CaseForm::FormBuilder' do
    case_fields_for(@user) { |f| assert f.instance_of?(CaseForm::FormBuilder) }
  end
  
  test 'should remote_case_form_for be an instance of CaseForm::FormBuilder' do
    remote_case_form_for(@user) { |f| assert f.instance_of?(CaseForm::FormBuilder) }
  end
  
  test "should generate <form> attributes" do
    concat(case_form_for(@user) { |f| })
    assert_select "form.case_form"
  end
  
  test "should generate remote <form> attributes" do
    concat(remote_case_form_for(@user) { |f| })
    assert_select "form[data-remote=true]"
  end
end