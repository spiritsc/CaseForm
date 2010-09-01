module CaseForm
  module Errors
    # == Error messages
    #
    # Creates a list with all errors on object (same as *error_messages_for* in Rails2).
    # Available is full configuration of every element in error list. 
    # Elements of list can be seperated for each error (*list* type) or grouped by attribute
    # (*sentence* type). Type of elements list should be defined in CaseForm config or options.
    #
    # == List type
    # 
    #   # object.errors = { :name => ['can't be blank', 'should be uniq'],
    #                       :price => 'should be more than 10' }
    #
    #   # errors:
    #     Name can't be blank
    #     Name should be uniq
    #     Price should be more than 10
    #
    # == Sentence type
    # 
    #   # object.errors = { :name => ['can't be blank', 'should be uniq'],
    #                       :price => 'should be more than 10' }
    #
    #   # errors:
    #     Name can't be blank and should be uniq
    #     Price should be more than 10
    #
    # == Error messages elements
    #
    # * main container
    # * header message - excluded if +:header_message+ is *false*
    # * message - excluded if +:message+ is *false*
    # * list of errors
    #
    # == Default error messages config
    # 
    # * CaseForm.error_tag
    # * CaseForm.error_type
    # * CaseForm.error_connector
    # * CaseForm.last_error_connector
    # * CaseForm.complex_error_header_tag
    # * CaseForm.complex_error_message_tag
    # 
    # == Examples:
    # 
    #   # @user.errors = { :firstname => ["can't be blank", "should be uniq"], 
    #                      :lastname  => "can't be blank" }
    #
    #   # Generate list of errors as list
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.errors
    #   <% end %>
    #
    #   <div class="errors" id="user_errors">
    #     <h2>Some errors prohibited this object from being saved</h2>
    #     <p>There were problems with the following fields:</p>
    #     <ul>
    #       <li>Firstname can't be blank</li>
    #       <li>Firstname should be uniq</li>
    #       <li>Lastname can't be blank</li>
    #     </ul>
    #   </div>
    #
    #   # Generate list of errors as sentence
    # 
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.errors
    #   <% end %>
    #
    #   <div class="errors" id="user_errors">
    #     <h2>Some errors prohibited this object from being saved</h2>
    #     <p>There were problems with the following fields:</p>
    #     <ul>
    #       <li>Firstname can't be blank and should be uniq</li>
    #       <li>Lastname can't be blank</li>
    #     </ul>
    #   </div>
    # 
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:tag+ - container tag, overwrite CaseForm config
    # * +:as+ - list type, overwrite CaseForm config (supported values: +:list+ and +:sentence+)
    # * +:header_tag+ - header tag
    # * +:header_message+ - header message
    # * +:message_tag+ - message tag
    # * +:message+ - message
    # * +:connector+ - connector for sentence, default is ', '
    # * +:last_connector+ - last connector for sentence, default is ' and '
    #
    # == Header message I18n lookups priority:
    #
    # * "activemodel.errors.template.header_message"
    # * "activerecord.errors.template.header_message"
    # * "case_form.errors.template.header_message"
    # * "Some errors prohibited this object from being saved"
    #
    # == Message I18n lookups priority:
    #
    # * "activemodel.errors.template.message"
    # * "activerecord.errors.template.message"
    # * "case_form.errors.template.message"
    # * "There were problems with the following fields:"
    #
    def error_messages(options={})
      Element::ComplexError.new(self, options).generate if object.errors.any?
    end
    alias_method :error_messages_for, :error_messages
    alias_method :errors_for, :error_messages
    alias_method :errors, :error_messages
    
    # == Error messages on method
    #
    # Creates a list with all errors on method in object. 
    # Elements of list can be seperated for each error (*list* type) or grouped (*sentence* type). 
    # Type of elements list should be defined in CaseForm config or options.
    #
    # == List type
    # 
    #   # object.errors = { :name => ['can't be blank', 'should be uniq'],
    #                       :price => 'should be more than 10' }
    #
    #   # errors on firstname:
    #     can't be blank
    #     should be uniq
    #
    # == Sentence type
    # 
    #   # object.errors = { :name => ['can't be blank', 'should be uniq'],
    #                       :price => 'should be more than 10' }
    #
    #   # errors on firstname:
    #     can't be blank and should be uniq
    #
    # == Default error messages config
    # 
    # * CaseForm.error_tag
    # * CaseForm.error_type
    # * CaseForm.error_connector
    # * CaseForm.last_error_connector
    # 
    # == Examples:
    # 
    #   # @user.errors = { :firstname => ["can't be blank", "should be uniq"], 
    #                      :lastname  => "can't be blank" }
    #
    #   # Generate list of errors as list
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.error :firstname
    #   <% end %>
    #
    #   <div class="error" id="user_firstname_error">
    #     <ul>
    #       <li>can't be blank</li>
    #       <li>should be uniq</li>
    #     </ul>
    #   </div>
    #
    #   # Generate list of errors as sentence
    # 
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.error :firstname
    #   <% end %>
    #
    #   <div class="error" id="user_firstname_error">
    #     can't be blank and should be uniq
    #   </div>
    # 
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:tag+ - container tag, overwrite CaseForm config
    # * +:as+ - list type, overwrite CaseForm config (supported values: +:list+ and +:sentence+)
    # * +:connector+ - connector for sentence, default is ', '
    # * +:last_connector+ - last connector for sentence, default is ' and '
    #
    def error_message(method, options={})
      Element::SimpleError.new(self, method, options).generate if object.errors[method].any?
    end
    alias_method :error_message_on, :error_message
    alias_method :error_on, :error_message
    alias_method :error, :error_message
  end
end