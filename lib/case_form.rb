# coding: utf-8
require 'action_view'
require 'case_form/core_ext/sentence_error'
require 'case_form/core_ext/form_helper'
require 'case_form/core_ext/layout_helper'

module CaseForm
  autoload :FormBuilder,  'case_form/form_builder'
  autoload :Element,      'case_form/element'
  autoload :Inputs,       'case_form/inputs'
  autoload :Associations, 'case_form/associations'
  autoload :Buttons,      'case_form/buttons'
  autoload :Labels,       'case_form/labels'
  autoload :Errors,       'case_form/errors'
  
  def self.config
    yield self
  end
  
  mattr_accessor :input_elements
  @@input_elements = [:label, :input, :error, :hint]
  
  mattr_accessor :nested_model_elements
  @@nested_model_elements = [:nested_model, :destructor, :generator]
  
  mattr_accessor :form_buttons
  @@form_buttons = [:commit, :reset]
  
  mattr_accessor :locked_columns
  @@locked_columns = [:id, :type, :lock_version, :version,
                      :created_at, :updated_at, :created_on, :updated_on]
                      
  mattr_accessor :input_types
  @@input_types = [:string, :text, :hidden, :password, :search, 
                   :email, :url, :telephone, :file,
                   :datetime, :date, :time, :number, :range,
                   :checkbox, :radio, :select,
                   :association, :has_many, :has_one, :belongs_to]
  
  mattr_accessor :require_symbol
  @@require_symbol = "*"
  
  mattr_accessor :all_fields_required
  @@all_fields_required = false
  
  mattr_accessor :input_size
  @@input_size = 50
  
  mattr_accessor :textarea_cols
  @@textarea_cols = 20
  
  mattr_accessor :textarea_rows
  @@textarea_rows = 10
  
  mattr_accessor :number_step
  @@number_step = 1
  
  mattr_accessor :wrapper_tag
  @@wrapper_tag = :div
  
  mattr_accessor :hint_tag
  @@hint_tag = :span
  
  mattr_accessor :error_tag
  @@error_tag = :div
  
  # :sentence, :list
  mattr_accessor :error_type
  @@error_type = :sentence
  
  mattr_accessor :error_connector
  @@error_connector = ", "
  
  mattr_accessor :last_error_connector
  @@last_error_connector = " and "
  
  mattr_accessor :complex_error_header_tag
  @@complex_error_header_tag = :h2
  
  mattr_accessor :complex_error_message_tag
  @@complex_error_message_tag = :p
  
  mattr_accessor :collection_label_methods
  @@collection_label_methods = [:to_label, :full_name, :fullname, :name, :title, :login, :email, :value, :to_s]
  
  mattr_accessor :collection_value_methods
  @@collection_value_methods = [:id]
end