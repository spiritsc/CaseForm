# coding: utf-8
module CaseForm
  module Labels
    # == Label
    # 
    # Generate label for model attribute. By default it use I18n translation (see lookups).
    # If method is required by validation or attribute column option, should add required symbol.
    #
    # == Label config
    # 
    # * CaseForm.all_fields_required
    # * CaseForm.require_symbol
    #
    #
    # == Examples:
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.label :firstname %>                   # Uses I18n lookup
    #   <% end %>
    #   
    #   # or
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.label :firstname, :text => "Your firstname" %>            
    #                                                 # Overwrite I18n lookup
    #   <% end %>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:for+ - label's target 
    # * +:text+ - text for label, overwrite a default value
    # * +:required+ - add "required" symbol to label if attribute is needed by validation or as column option "NULL" 
    #
    # == I18n lookups priority:
    #
    # * 'activerecord.attributes.{{model}}.{{method}}'
    # * 'activemodel.attributes.{{model}}.{{method}}'
    # * 'case_form.attributes.{{model}}.{{method}}'
    # * humanized method
    #
    def label(method, options={})
      Element::Label.new(self, method, options).generate
    end
    
    # == Form hint for input
    # 
    # Generate hint for input as simple HTML tag. Hints can be use for model attribute - it use I18n 
    # for translate. You can also enter just some string as argument or +:text+ option for different situation.
    # I18n lookup see bottom.
    #
    # == Hint config
    # 
    # * CaseForm.hint_tag
    #
    # == Examples for model attribute:
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.hint :firstname %>                    # Uses I18n lookup  
    #   <% end %>
    #   
    #   # or
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.hint :firstname, :text => "Enter your firstname" %>       
    #                                                 # Overwrite I18n lookup
    #   <% end %>
    #
    # == Examples for non model attribute:
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.hint "Enter your firstname" %>        # Uses string argument
    #   <% end %>
    #
    # == Allowed options:
    #
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:text+ - text for hint, overwrite a I18n or string value
    # * +:tag+ - hint's HTML tag
    #
    # == I18n lookups priority:
    #
    # * 'case_form.hints.{{model}}.{{method}}'
    #
    def hint(method_or_string, options={})
      Element::Hint.new(self, method_or_string, options).generate
    end
    alias_method :comment, :hint
  end
end