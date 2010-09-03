CaseForm.config do |c|
  c.input_elements = [:label, :input, :error, :hint]
  
  c.form_buttons   = [:commit, :reset]
  
  c.locked_columns = [:id, :type, :lock_version, :version,
                      :created_at, :updated_at, :created_on, :updated_on]
                      
  c.all_fields_required = false
  
  c.require_symbol = "*"
  
  c.input_size = 50
  
  c.textarea_cols = 20
  
  c.textarea_rows = 10
  
  c.number_step = 1
  
  c.wrapper_tag = :div
  
  c.hint_tag = :span
  
  c.error_tag = :div
  
  c.error_type = :sentence
  
  c.error_connector = ", "
  
  c.last_error_connector = " and "
  
  c.complex_error_header_tag = :h2
  
  c.complex_error_message_tag = :p
  
  c.collection_label_methods = [:to_label, :full_name, :fullname, :name, :title, :login, :email, :value, :to_s]
  
  c.collection_value_methods = [:id]
end