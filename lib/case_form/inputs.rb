# coding: utf-8
module CaseForm
  module Inputs
    # == Attributes with or without block
    #
    # Creates fieldset for inputs. With no block or arguments (except allowed options for fieldset)
    # it generates for each model column (without locked columns) a specific input. Also can create 
    # only for specified attributes in model as list of arguments in method.
    #
    # Every input has specified type (support for HTML5).
    #
    # == Input elements:
    #
    # * label
    # * input
    # * hint - if hint exist
    # * error - if method has errors
    #
    # To change list of elements (global) for each attribute go to CaseForm config.
    #
    # == Examples:
    # 
    #   # Short form with all model columns 
    #   # (imagine that User.column_names = [:id, :firstname, :lastname, :email, :created_at, :updated_at])
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.attributes %>                           # Create inputs for all columns
    #   <% end %>
    #
    #   <fieldset class="fieldset">
    #     <div class="inputs">
    #       <label class="label" for="user_firstname">Firstname</label>
    #       <input class="input" id="user_firstname" name="user[firstname]" type="text" />
    #     </div>
    #     <div class="inputs">
    #       <label class="label" for="user_lastname">Lastname</label>
    #       <input class="input" id="user_lastname" name="user[lastname]" type="text" />
    #     </div>
    #     <div class="inputs">
    #       <label class="label" for="user_email">Email</label>
    #       <input class="input" id="user_email" name="user[email]" type="email" />
    #     </div>
    #   </fieldset>
    #
    #   # Form with specified attributes in arguments
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.attributes(:firstname, :lastname) %>    # Create inputs for firstname and lastname 
    #   <% end %>
    #
    #   <fieldset class="fieldset">
    #     <div class="inputs">
    #       <label class="label" for="user_firstname">Firstname</label>
    #       <input class="input" id="user_firstname" name="user[firstname]" type="text" />
    #     </div>
    #     <div class="inputs">
    #       <label class="label" for="user_lastname">Lastname</label>
    #       <input class="input" id="user_lastname" name="user[lastname]" type="text" />
    #     </div>
    #   </fieldset>
    #
    #   # Attributes in block
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.attributes do %>
    #       <%= f.string :firstname %>
    #       <%= f.email :email %>
    #     <% end %>
    #   <% end %>
    #
    #   <fieldset class="fieldset">
    #     <div class="inputs">
    #       <label class="label" for="user_firstname">Firstname</label>
    #       <input class="input" id="user_firstname" name="user[firstname]" type="text" />
    #     </div>
    #     <div class="inputs">
    #       <label class="label" for="user_email">Email</label>
    #       <input class="input" id="user_email" name="user[email]" type="email" />
    #     </div>
    #   </fieldset>
    #
    # == Default attributes config
    # 
    # * CaseForm.input_elements
    # * CaseForm.locked_columns
    # 
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:text+ - legend for fieldset
    # For more advanced options for each attribute use block.
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
    
    # == Attribute with dynamic type
    # 
    # Creates a input with elements defined in CaseForm config or options for method. 
    # Supports association and simple methods, generating for them right type of input. 
    # Using option +:as+ can be specified the type yourself.
    #
    # == Input elements:
    #
    # * label
    # * input
    # * hint - if hint exist
    # * error - if method has errors
    #
    # 
    # == Input types:
    # * +:string+
    # * +:text+
    # * +:hidden+
    # * +:password+
    # * +:email+
    # * +:url+
    # * +:telephone+
    # * +:search+
    # * +:file+
    # * +:datetime+
    # * +:date+
    # * +:time+
    # * +:number+
    # * +:range+
    # * +:checkbox+
    # * +:radio+
    # * +:select+
    # * +:association+
    # * +:has_many+
    # * +:has_one+
    # * +:belongs_to+
    # 
    # == Examples:
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.string :firstname %>
    #     <%= f.email :email %>
    #   <% end %>
    #
    #   <div class="inputs">
    #     <label class="label" for="user_firstname">Firstname</label>
    #     <input class="input" id="user_firstname" name="user[firstname]" type="text" />
    #   </div>
    #   <div class="inputs">
    #     <label class="label" for="user_email">Email</label>
    #     <input class="input" id="user_email" name="user[email]" type="email" />   # email type
    #   </div>
    #   
    #   # with own input type
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.email :email, :as => :string %>
    #   <% end %>
    #
    #   <div class="inputs">
    #     <label class="label" for="user_email">Email</label>
    #     <input class="input" id="user_email" name="user[email]" type="text" />    # text type
    #   </div>
    #
    #   # without some element (for example label)
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.email :email, :label => false %>
    #   <% end %>
    #
    #   <div class="inputs">
    #     <input class="input" id="user_email" name="user[email]" type="email" />
    #   </div>
    #
    #   # with label/hint options as hash
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.email :email, :label => { :text => "E-mail", :id => "email_label"} %>
    #   <% end %>
    #
    #   <div class="inputs">
    #     <label class="label" for="user_email" id="email_label">E-mail</label>
    #     <input class="input" id="user_email" name="user[email]" type="email" />
    #   </div>
    #
    #   # with text label/hint
    #
    #   <&= case_form_for @user do |f| &>
    #     <%= f.email :email, :hint => "enter your e-mail" %>
    #   <% end %>
    #
    #   <div class="inputs">
    #     <label class="label" for="user_email">Email</label>
    #     <input class="input" id="user_email" name="user[email]" type="email" />
    #     <span>enter your e-mail</span>
    #   </div>
    #
    # == Default attribute config:
    # 
    # * CaseForm.input_types
    # * CaseForm.input_limit
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * and much more for each input type 
    #
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
    
    # == Text field
    #
    # Creates text field with defined input elements. HTML input attribute *size* is defined from
    # +validates_length_of+ and option +:maximum+ validation or from CaseForm config.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.string(:firstname)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_firstname" id="user_firstname_label">Firstame</label>
    #     <input class="input" id="user_firstname" name="user[firstname]" size="50" type="text" value="" />
    #   </div>
    #
    # == Default text field config:
    # 
    # * CaseForm.input_size
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:size+ - input size (default value in CaseForm config)
    # * +:maxlength+ - max lenght of text
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:pattern+ - Javascript pattern of text (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def string(method, options={})
      Element::StringInput.new(self, method, options.merge(:as => :text)).generate
    end
    
    # == Text area
    #
    # Creates text area with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.text(:firstname)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_firstname" id="user_firstname_label">Firstname</label>
    #     <textarea class="input" cols="40" id="user_firstname" name="user[firstname]" rows="20"></textarea>
    #   </div>
    #
    # == Default attribute config:
    # 
    # * CaseForm.textarea_cols
    # * CaseForm.textarea_rows
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:cols+ - textarea cols (default value in CaseForm config)
    # * +:rows+ - textarea rows (default value in CaseForm config)
    # * +:maxlength+ - max lenght of text
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def text(method, options={})
      Element::TextInput.new(self, method, options).generate
    end
    
    # == Hidden field
    #
    # Generates hidden field without any elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.hidden(:firstname)
    #   end
    #
    #   <input class="input hidden" id="user_firstname" name="user[firstname]" type="hidden" value="" />
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    #
    def hidden(method, options={})
      Element::HiddenInput.new(self, method, options).generate
    end
    
    # == Password field
    #
    # Generate password field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.password(:password)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_password" id="user_password_label">Password</label>
    #     <input class="input" id="user_password" name="user[password]" size="50" type="password" value="" />
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:size+ - input size (default value in CaseForm config)
    # * +:maxlength+ - max lenght of text
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:pattern+ - Javascript pattern of text (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def password(method = :password, options={})
      Element::StringInput.new(self, method, options.merge(:as => :password)).generate
    end
    
    # == Search field
    #
    # Generate search field with label (without hint and error).
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.search(:firstname)
    #   end
    #
    #   <div class="inputs search">
    #     <label class="label" for="user_firstname" id="user_firstname_label">Firstname</label>
    #     <input class="input" id="user_firstname" name="user[firstname]" size="50" type="search" value="" />
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    #
    def search(method, options={})
      Element::StringInput.new(self, method, options.merge(:as => :search)).generate
    end
    
    # == Email field
    #
    # Generate email field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.email(:email)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_email" id="user_email_label">Email</label>
    #     <input class="input" id="user_email" name="user[email]" size="50" type="email" value="" />
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:size+ - input size (default value in CaseForm config)
    # * +:maxlength+ - max lenght of text
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:pattern+ - Javascript pattern of text (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def email(method = :email, options={})
      Element::StringInput.new(self, method, options.merge(:as => :email)).generate
    end
    alias_method :mail, :email
    
    # == URL field
    #
    # Generate URL field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.url(:profile_url)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_profile_url" id="user_profile_url_label">Profile url</label>
    #     <input class="input" id="user_profile_url" name="user[profile_url]" size="50" type="url" value="" />
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:size+ - input size (default value in CaseForm config)
    # * +:maxlength+ - max lenght of text
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:pattern+ - Javascript pattern of text (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def url(method = :url, options={})
      Element::StringInput.new(self, method, options.merge(:as => :url)).generate
    end
    alias_method :http, :url
    
    # == Telephone field
    #
    # Generate telephone field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.telephone(:telephone)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_telephone" id="user_telephone_label">Telephone</label>
    #     <input class="input" id="user_telephone" name="user[telephone]" size="50" type="tel" value="" />
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:size+ - input size (default value in CaseForm config)
    # * +:maxlength+ - max lenght of text
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:pattern+ - Javascript pattern of text (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def telephone(method = :telephone, options={})
      Element::StringInput.new(self, method, options.merge(:as => :telephone)).generate
    end
    alias_method :tel, :telephone
    alias_method :phone, :telephone
    
    # == Datetime field
    #
    # Generate datetime field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.datetime(:created_at)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_created_at" id="user_created_at_label">Created at</label>
    #     <select class="input" id="user_created_at_1i" name="user[created_at(1i)]">
    #       <option>...</option>          # Options for year
    #     <select> 
    #     <select class="input" id="user_created_at_2i" name="user[created_at(2i)]">
    #       <option>...</option>          # Options for month
    #     </select>
    #     <select class="input" id="user_created_at_3i" name="user[created_at(3i)]">
    #       <option>...</option>          # Options for day
    #     </select>
    #     <select class="input" id="user_created_at_4i" name="user[created_at(4i)]">
    #       <option>...</option>          # Options for hour
    #     </select>
    #     <select class="input" id="user_created_at_5i" name="user[created_at(5i)]">
    #       <option>...</option>          # Options for minute
    #     </select>
    #   </div>
    #
    #   # only year and month select
    #
    #   case_form_for(@user) do |f|
    #     f.datetime(:created_at, :elements => [:year, :month])
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_created_at" id="user_created_at_label">Created at</label>
    #     <select class="input" id="user_created_at_1i" name="user[created_at(1i)]">
    #       <option>...</option>          # Options for year
    #     <select> 
    #     <select class="input" id="user_created_at_2i" name="user[created_at(2i)]">
    #       <option>...</option>          # Options for month
    #     </select>
    #   </div>
    #
    #   # without minute select
    #
    #   case_form_for(@user) do |f|
    #     f.datetime(:created_at, :minute => false)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_created_at" id="user_created_at_label">Created at</label>
    #     <select class="input" id="user_created_at_1i" name="user[created_at(1i)]">
    #       <option>...</option>          # Options for year
    #     <select> 
    #     <select class="input" id="user_created_at_2i" name="user[created_at(2i)]">
    #       <option>...</option>          # Options for month
    #     </select>
    #     <select class="input" id="user_created_at_3i" name="user[created_at(3i)]">
    #       <option>...</option>          # Options for day
    #     </select>
    #     <select class="input" id="user_created_at_4i" name="user[created_at(4i)]">
    #       <option>...</option>          # Options for hour
    #     </select>
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:elements+ - elements of datetime field (available: +:year+, +:month+, +:day+, +:hour+, +:minute+, +:second+)
    # * +:datetime_separator+ - separator for each datetime select
    # * +:separator+ - alias for +:datetime_separator+
    # * +:date_separator+ - separator for each date select
    # * +:time_separator+ - separator for each time select
    # * +:year+ - year select (available options: +:start+ as start year, +:end+ as end year or *false* to not create)
    # * +:start_year+ - overwrite <tt>:year => { :start => ... }</tt> option
    # * +:end_year+ - overwrite <tt>:year => { :end => ... }</tt> option
    # * +:month+ - month select (available options: +:names+ as month names, +:short+ to use short names or *false* to not create)
    # * +:short_month+ - overwrite <tt>:month => { :short => ... }</tt> option
    # * +:day+ - day select (*false* to not create)
    # * +:hour+ - hour select (*false* to not create)
    # * +:minute+ - minute select (available options: +:step+ or *false* to not create)
    # * +:minute_step+ - overwrite <tt>:minute => { :step => ...}</tt> option
    # * +:second+ - hour select (default *false* and not create)
    # * +:datetime+ - selected datetime
    # * +:default+ - alias for +:datetime+ option
    # * +:prompt+ - custom messages for each select (available options: +:year+, +:month+ ... or *true* for auto)
    # * +:blank+ - include blank option for each select
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def datetime(method, options={})
      Element::DateTimeInput.new(self, method, options).generate
    end
    
    # Generate date field
    #
    # Generate telephone field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.telephone(:telephone)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_telephone" id="user_telephone_label">Telephone</label>
    #     <input class="input" id="user_telephone" name="user[telephone]" size="50" type="tel" value="" />
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:autofocus+ - HTML autofocus
    # * +:required+ - overwrite required field
    # * +:label+ - label options (*false* to not create)
    # * +:hint+ - hint options (*false* to not create)
    # * +:error+ - error options (*false* to not create)
    # * +:size+ - input size (default value in CaseForm config)
    # * +:maxlength+ - max lenght of text
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:pattern+ - Javascript pattern of text (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
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