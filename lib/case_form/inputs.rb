# coding: utf-8
module CaseForm
  module Inputs
    # Generate block for fields
    #
    # === Short forms
    # 
    # If you use :attributes method without any block or arguments (except allowed options for fieldset)
    # it will generate form with all model columns as inputs.
    # 
    # Example: 
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.attributes %>
    #   <% end %>
    # 
    # Allowed fieldset options: 
    # * :id - HTML ID of fieldset 
    # * :class - HTML class of fieldset
    # * :style - not recommended styles for fieldset
    # * :text - text legend for fieldset
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    def attributes(*args, &block)
      options = args.extract_options!
      
      fieldset = Element::Fieldset.new(self, options)
      
      if block_given?
        fieldset.generate(&block)
      else
        args  = object.class.column_names if args.empty?
        args -= CaseForm.locked_columns.collect! { |c| c.to_s }
        fieldset.generate(args.collect { |a| attribute(a) })
      end
    end
    alias_method :inputs, :attributes
    
    # Generate dynamic input with label, hint and optional errors
    def attribute(method, options={})
      if options.has_key?(:as)
        type, input_types = options.delete(:as), CaseForm.input_types
        raise(ArgumentError, "Unknown input type: #{type}. Available types: #{input_types.join(', ')}") unless input_types.include?(type.to_sym)
        send(type, method, options)
      elsif object.class.reflect_on_association(method)
        association(method, options)
      else
        specified_input(method, options)
      end
    end
    alias_method :input, :attribute
    
    # Generate text field with label, hint and optional errors
    # Example:
    # => case_form_for(@user) do |f|
    #      f.string(:name)
    #    end
    #
    # => <form accept-charset="UTF-8" action="/users/" class="case_form user" id="new_user" method="post">
    #    ...
    #      <div class="case_form inputs">
    #        <label class="case_form label" for="user_name" id="user_name_label">Name</label>
    #        <input class="case_form input" id="user_name" name="user[name]" size="50" type="text" value="" />
    #      </div>
    #    </form>     
    def string(method, options={})
      Element::StringInput.new(self, method, options.merge(:as => :text)).generate
    end
    
    # Generate text area with label, hint and optional errors
    # Example:
    # => case_form_for(@user) do |f|
    #      f.text(:description)
    #    end
    #
    # => <form accept-charset="UTF-8" action="/users/" class="case_form user" id="new_user" method="post">
    #    ...
    #      <div class="case_form inputs">
    #        <label class="case_form label" for="user_description" id="user_description_label">Description</label>
    #        <textarea class="case_form input" cols="40" id="user_description" name="user[description]" rows="20"></textarea>
    #      </div>
    #    </form>
    def text(method, options={})
      Element::TextInput.new(self, method, options).generate
    end
    
    # Generate hidden field with label, hint and optional errors
    # Example:
    # => case_form_for(@user) do |f|
    #      f.hidden(:name)
    #    end
    #
    # => <form accept-charset="UTF-8" action="/users/" class="case_form user" id="new_user" method="post">
    #    ...
    #      <input class="case_form input hidden" id="user_name" name="user[name]" type="hidden" value="" />
    #    </form>
    def hidden(method, options={})
      Element::HiddenInput.new(self, method, options).generate
    end
    
    # Generate password field with label, hint and optional errors
    # Example:
    # => case_form_for(@user) do |f|
    #      f.password(:password)
    #    end
    #
    # => <form accept-charset="UTF-8" action="/users/" class="case_form user" id="new_user" method="post">
    #    ...
    #      <div class="case_form inputs">
    #        <label class="case_form label" for="user_password" id="user_password_label">Password</label>
    #        <input class="case_form input" id="user_password" name="user[password]" size="50" type="password" value="" />
    #      </div>
    #    </form>
    def password(method = :password, options={})
      Element::StringInput.new(self, method, options.merge(:as => :password)).generate
    end
    
    # Generate search field with label, hint and optional errors
    def search(method, options={})
      Element::StringInput.new(self, method, options.merge(:as => :search)).generate
    end
    
    # Generate email field
    # Example:
    # => case_form_for(@user) do |f|
    #      f.email(:email)
    #    end
    #
    # => <form accept-charset="UTF-8" action="/users/" class="case_form user" id="new_user" method="post">
    #    ...
    #      <div class="case_form inputs">
    #        <label class="case_form label" for="user_email" id="user_email_label">Email</label>
    #        <input class="case_form input" id="user_email name="user[email]" size="50" type="email" value="" />
    #      </div>
    #    </form>
    def email(method = :email, options={})
      Element::StringInput.new(self, method, options.merge(:as => :email)).generate
    end
    alias_method :mail, :email
    
    # Generate URL field with label, hint and optional errors
    # Example:
    # => case_form_for(@user) do |f|
    #      f.url(:url)
    #    end
    #
    # => <form accept-charset="UTF-8" action="/users/" class="case_form user" id="new_user" method="post">
    #    ...
    #      <div class="case_form inputs">
    #        <label class="case_form label" for="user_url" id="user_url_label">URL</label>
    #        <input class="case_form input" id="user_url name="user[url]" size="50" type="url" value="" />
    #      </div>
    #    </form>
    def url(method = :url, options={})
      Element::StringInput.new(self, method, options.merge(:as => :url)).generate
    end
    alias_method :http, :url
    
    # Generate telephone field with label, hint and optional errors
    # Example:
    # => case_form_for(@user) do |f|
    #      f.telephone(:phone)
    #    end
    #
    # => <form accept-charset="UTF-8" action="/users/" class="case_form user" id="new_user" method="post">
    #    ...
    #      <div class="case_form inputs">
    #        <label class="case_form label" for="user_phone" id="user_phone_label">Phone</label>
    #        <input class="case_form input" id="user_phone name="user[phone]" size="50" type="tel" value="" />
    #      </div>
    #    </form>
    def telephone(method = :telephone, options={})
      Element::StringInput.new(self, method, options.merge(:as => :telephone)).generate
    end
    alias_method :tel, :telephone
    alias_method :phone, :telephone
    
    # Generate datetime field
    def datetime(method, options={})
      Element::DateTimeInput.new(self, method, options).generate
    end
    
    # Generate date field
    def date(method, options={})
      Element::DateInput.new(self, method, options).generate
    end
    
    # Generate time field
    def time(method, options={})
      Element::TimeInput.new(self, method, options).generate
    end
    
    def time_zone(method, options={})
      Element::TimeZoneInput.new(self, method, options).generate
    end
    
    # Generate file field
    def file(method, options={})
      Element::FileInput.new(self, method, options).generate
    end
    
    # Generate checkbox field
    def checkbox(method, options={})
      Element::CheckboxInput.new(self, method, options).generate
    end
    
    # Generate select field
    def select(method, options={})
      Element::SelectInput.new(self, method, options).generate
    end
    
    # Generate radio field
    def radio(method, options={})
      Element::RadioInput.new(self, method, options).generate
    end
    
    # Generate number field
    def number(method, options={})
      Element::NumberInput.new(self, method, options.merge(:as => :number)).generate
    end
    
    # Generate range field
    def range(method, options={})
      Element::NumberInput.new(self, method, options.merge(:as => :range)).generate
    end
    
    private
      def specified_input(method, options)
        input = case method.to_s
        when /password/ then :password
        when /file/     then :file
        when /mail/     then :email
        when /url/      then :url
        when /phone/    then :telephone
        when /zone/     then :time_zone
        when /_id/      then :belongs_to
        else 
          case object.column_for_attribute(method).type
          when (:string || :binary)             then :string
          when :text                            then :text
          when (:integer || :float || :decimal) then :number
          when :datetime                        then :datetime
          when :date                            then :date
          when (:timestamp || :time)            then :time
          when :boolean                         then :checkbox
          else
            :string
          end
        end
        send(input, method, options)
      end
  end
end