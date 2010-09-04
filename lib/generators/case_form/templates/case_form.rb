CaseForm.config do |c|
  # Default input elements for each form field
  # To remove for example inline errors for single field delete symbol from this array
  c.input_elements = [:label, :input, :error, :hint]
  
  # Default form buttons
  c.form_buttons = [:commit, :reset]
  
  # Collection of locked columns for dynamic attribute finder (in "attributes" method)
  c.locked_columns = [:id, :type, :lock_version, :version,
                      :created_at, :updated_at, :created_on, :updated_on]
  
  # All fields required in every form by default
  c.all_fields_required = false
  
  # Required symbol in form label
  c.require_symbol = "*"
  
  # Default input size
  c.input_size = 50
  
  # Default count of textarea cols
  c.textarea_cols = 20
  
  # Default count of textarea rows
  c.textarea_rows = 10
  
  # Default step for number input
  c.number_step = 1
  
  # Default wrapper tag for each form field
  c.wrapper_tag = :div
  
  # Default hint tag
  c.hint_tag = :span
  
  # Default error tag (same for complex and simple errors)
  c.error_tag = :div
  
  # Default error type (available options are :list and :sentence)
  # Differences between types search in CaseForm documentation (:error_messages and :error_message methods)
  c.error_type = :sentence
  
  # Default connector for sentence errors type
  # Example: some error, another error, just error
  c.error_connector = ", "
  
  # Default last connector for sentence errors type
  # Example: some error, another error, just error and last error
  c.last_error_connector = " and "
  
  # Default header tag for complex errors
  c.complex_error_header_tag = :h2
  
  # Default message tag for complex errors
  c.complex_error_message_tag = :p
  
  # Collection of methods for label in associated model (first found is taken)
  c.collection_label_methods = [:to_label, :full_name, :fullname, :name, :title, :login, :email, :value, :to_s]
  
  # Collection of methods for value in associated model (first found is taken)
  c.collection_value_methods = [:id]
end