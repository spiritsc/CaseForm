module CaseForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include CaseForm::Inputs
    include CaseForm::Associations
    include CaseForm::Buttons
    include CaseForm::Labels
    include CaseForm::Errors
    
    attr_reader :template, :object_name, :object, :options
  end
end