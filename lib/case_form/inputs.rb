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
      options[:class] ||= :inputs
      
      fieldset = Element::Fieldset.new(self, options)
      
      if block_given?
        fieldset.generate(&block)
      else
        args  = object.class.content_columns.map(&:name) if args.empty?
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
    
    # == Date field
    #
    # Generate date field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.date(:born_at)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_born_at" id="user_born_at_label">Born at</label>
    #     <select class="input" id="user_born_at_1i" name="user[born_at(1i)]">
    #       <option>...</option>          # Options for year
    #     <select> 
    #     <select class="input" id="user_born_at_2i" name="user[born_at(2i)]">
    #       <option>...</option>          # Options for month
    #     </select>
    #     <select class="input" id="user_born_at_3i" name="user[born_at(3i)]">
    #       <option>...</option>          # Options for day
    #     </select>
    #   </div>
    #
    #   # without day
    #
    #   case_form_for(@user) do |f|
    #     f.date(:born_at, :day => false)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_born_at" id="user_born_at_label">Born at</label>
    #     <select class="input" id="user_born_at_1i" name="user[born_at(1i)]">
    #       <option>...</option>          # Options for year
    #     <select> 
    #     <select class="input" id="user_born_at_2i" name="user[born_at(2i)]">
    #       <option>...</option>          # Options for month
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
    # * +:elements+ - elements of date field (available: +:year+, +:month+, +:day+)
    # * +:separator+ - date separator (default: " - ")
    # * +:year+ - year select (available options: +:start+ as start year, +:end+ as end year or *false* to not create)
    # * +:start_year+ - overwrite <tt>:year => { :start => ... }</tt> option
    # * +:end_year+ - overwrite <tt>:year => { :end => ... }</tt> option
    # * +:month+ - month select (available options: +:names+ as month names, +:short+ to use short names or *false* to not create)
    # * +:short_month+ - overwrite <tt>:month => { :short => ... }</tt> option
    # * +:day+ - day select (*false* to not create)
    # * +:date+ - selected date
    # * +:default+ - alias for +:date+ option
    # * +:prompt+ - custom messages for each select (available options: +:year+, +:month+ and +:day+ or *true* for auto)
    # * +:blank+ - include blank option for each select
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def date(method, options={})
      Element::DateInput.new(self, method, options).generate
    end
    
    # == Time field
    #
    # Generate time field with defined input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.time(:login_at)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_login_at" id="user_login_at_label">Login at</label>
    #     <select class="input" id="user_login_at_4i" name="user[login_at(4i)]">
    #       <option>...</option>          # Options for hour
    #     <select> 
    #     <select class="input" id="user_login_at_5i" name="user[login_at(5i)]">
    #       <option>...</option>          # Options for minute
    #     </select>
    #   </div>
    #
    #   # with second
    #
    #   case_form_for(@user) do |f|
    #     f.date(:born_at, :elements => [:hour, :minute, :second])
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_login_at" id="user_login_at_label">Login at</label>
    #     <select class="input" id="user_login_at_4i" name="user[login_at(4i)]">
    #       <option>...</option>          # Options for hour
    #     <select> 
    #     <select class="input" id="user_login_at_5i" name="user[login_at(5i)]">
    #       <option>...</option>          # Options for minute
    #     </select>
    #     <select class="input" id="user_login_at_6i" name="user[login_at(6i)]">
    #       <option>...</option>          # Options for second
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
    # * +:elements+ - elements of time field (available: +:hour+, +:minute+, +:second+)
    # * +:separator+ - time separator (default " : ")
    # * +:minute_step+ - minute steps (for example: "15" gives values: ["00", "15", "30", "45"])
    # * +:date+ - add date fields as hidden
    # * +:time+ - selected time
    # * +:default+ - alias for +:time+ option
    # * +:prompt+ - custom messages for each select (available options: +:hour+, +:minute+ and +:second+ or *true* for auto)
    # * +:blank+ - include blank option for each select
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def time(method, options={})
      Element::TimeInput.new(self, method, options).generate
    end
    
    # == Time zone field
    #
    # Generate time zone field with input elements.
    # 
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.time(:time_zone)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_time_zone" id="user_time_zone_label">Time zone</label>
    #     <select class="input" id="user_time_zone" name="user[time_zone]">
    #       <option>...</option>
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
    # * +:priority_zones+ - collection of priority zones
    # * +:zones+ - collection of all time zones
    # * +:time_zone+ - selected time zone
    # * +:default+ - alias for +:time_zone+ option
    # * +:prompt+ - custom messages for select
    # * +:blank+ - include blank option for select
    # * +:placeholder+ - HTML placeholder (HTML5)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def time_zone(method, options={})
      Element::TimeZoneInput.new(self, method, options).generate
    end
    
    # == File field
    #
    # Generate file field with input elements. Remeber to add <tt>:multipart => true</tt> option in form!
    #
    # == Example:
    #
    #   case_form_for(@user, :multipart => true) do |f|
    #     f.file(:avatar)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_avatar" id="user_avatar_label">Avatar</label>
    #     <input class="input" id="user_avatar" name="user[avatar]" type="file" />
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
    # * +:multiple+ - allow upload multiple files
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def file(method, options={})
      Element::FileInput.new(self, method, options).generate
    end
    
    # == Checkbox field
    #
    # Generate simple or collection of checkboxes with input elements. Collection can have many of types.
    #
    # == Collection types:
    #
    # * association class - <tt>:collection => Country</tt>
    # * +Array+ with model objects - <tt>:collection => Country.priority</tt>
    # * +Array+ with label and value - <tt>:collection => [["Administrator", 1], ["Author", 2]]</tt>
    # * +Array+ with same labels and values - <tt>:collection => ["Administrator", "Author"]</tt>
    # * +Hash+ - <tt>:collection => { "Administrator" => 1, "Author" => 2 }</tt>
    # * +Range+ - <tt>:collection => 1..100</tt>
    #
    # Default collection is <tt>[["Yes", true], ["No", false]]</tt>
    #
    # == Example:
    #
    #   # With default collection
    #
    #   case_form_for(@user) do |f|
    #     f.checkbox(:admin)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_admin" id="user_admin_label">Admin</label>
    #     <input name="user[admin]" type="hidden" value="" />
    #     <input class="input" id="user_admin_true" name="user[admin]" type="checkbox" value="true" />
    #     <label class="label" for="user_admin_true" id="user_admin_true_label">Yes</label>
    #   </div>
    #
    #   # with array collection
    #   
    #   case_form_for(@user) do |f|
    #     f.checkbox(:role, :collection => [["Admin", 1], ["Author", 2], ["User", 3]])
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_role" id="user_role_label">Role</label>
    #     <input name="user[role]" type="hidden" value="" />
    #     <input class="input" id="user_role_1" name="user[role]" type="checkbox" value="1" />
    #     <label class="label" for="user_role_1" id="user_role_1_label">Administrator</label>
    #     <input name="user[role]" type="hidden" value="" />
    #     <input class="input" id="user_role_2" name="user[role]" type="checkbox" value="2" />
    #     <label class="label" for="user_role_2" id="user_role_2_label">Author</label>
    #     <input name="user[role]" type="hidden" value="" />
    #     <input class="input" id="user_role_3" name="user[role]" type="checkbox" value="3" />
    #     <label class="label" for="user_role_3" id="user_role_3_label">User</label>
    #   </div>
    #
    #   # with association class
    #
    #   # class User
    #   #  belongs_to :country
    #   # end
    #   
    #   case_form_for(@user) do |f|
    #     f.checkbox(:country, :collection => Country, :label_method => :short_name, :value_method => :id)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_country" id="user_country_label">Country</label>
    #     <input name="user[country_id]" type="hidden" value="" />
    #     <input class="input" id="user_country_1" name="user[country_id]" type="checkbox" value="1" />
    #     <label class="label" for="user_country_1" id="user_country_1_label">Poland</label>
    #     <input name="user[country_id]" type="hidden" value="" />
    #     <input class="input" id="user_country_2" name="user[country_id]" type="checkbox" value="2" />
    #     <label class="label" for="user_country_2" id="user_country_2_label">Spain</label>
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
    # * +:checked+ - list of checked values
    # * +:selected+ - same as +:checked+ option
    # * +:collection+ - collection of available values
    # * +:label_method+ - method for labels in collection
    # * +:value_method+ - method for values in collection
    # * +:unchecked_value+ - value for hidden input
    # * +:allow_multiple+ - allow multiple select (add "[]" to checkbox name)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def checkbox(method, options={})
      Element::CheckboxInput.new(self, method, options).generate
    end
    
    # == Select field
    def select(method, options={})
      Element::SelectInput.new(self, method, options).generate
    end
    
    # == Radio button field
    #
    # Generate simple or collection of radio's with input elements. Collection can have many of types.
    #
    # == Collection types:
    #
    # * association class - <tt>:collection => Country</tt>
    # * +Array+ with model objects - <tt>:collection => Country.priority</tt>
    # * +Array+ with label and value - <tt>:collection => [["Administrator", 1], ["Author", 2]]</tt>
    # * +Array+ with same labels and values - <tt>:collection => ["Administrator", "Author"]</tt>
    # * +Hash+ - <tt>:collection => { "Administrator" => 1, "Author" => 2 }</tt>
    # * +Range+ - <tt>:collection => 1..100</tt>
    #
    # Default collection is <tt>[["Yes", true], ["No", false]]</tt>
    #
    # == Example:
    #
    #   # With default collection
    #
    #   case_form_for(@user) do |f|
    #     f.radio(:admin)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_admin" id="user_admin_label">Admin</label>
    #     <input class="input" id="user_admin_true" name="user[admin]" type="radio" value="true" />
    #     <label class="label" for="user_admin_true" id="user_admin_true_label">Yes</label>
    #     <input class="input" id="user_admin_false" name="user[admin]" type="radio" value="false" />
    #     <label class="label" for="user_admin_false" id="user_admin_false_label">No</label>
    #   </div>
    #
    #   # with array collection
    #   
    #   case_form_for(@user) do |f|
    #     f.radio(:role, :collection => [["Admin", 1], ["Author", 2], ["User", 3]])
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_admin" id="user_admin_label">Admin</label>
    #     <input class="input" id="user_admin_1" name="user[admin]" type="radio" value="1" />
    #     <label class="label" for="user_admin_1" id="user_admin_1_label">Admin</label>
    #     <input class="input" id="user_admin_2" name="user[admin]" type="radio" value="2" />
    #     <label class="label" for="user_admin_2" id="user_admin_2_label">Author</label>
    #     <input class="input" id="user_admin_3" name="user[admin]" type="radio" value="3" />
    #     <label class="label" for="user_admin_3" id="user_admin_3_label">User</label>
    #   </div>
    #
    #   # with association class
    #
    #   # class User
    #   #  belongs_to :country
    #   # end
    #   
    #   case_form_for(@user) do |f|
    #     f.radio(:country, :collection => Country, :label_method => :short_name, :value_method => :id)
    #   end
    #
    #   <div class="inputs">
    #     <input class="input" id="user_country_id_1" name="user[country_id]" type="radio" value="1" />
    #     <label class="label" for="user_country_id_1" id="user_country_id_1_label">Poland</label>
    #     <input class="input" id="user_country_id_2" name="user[country_id]" type="radio" value="2" />
    #     <label class="label" for="user_country_id_2" id="user_country_id_2_label">Germany</label>
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
    # * +:checked+ - list of checked values
    # * +:selected+ - same as +:checked+ option
    # * +:collection+ - collection of available values
    # * +:label_method+ - method for labels in collection
    # * +:value_method+ - method for values in collection
    # * +:unchecked_value+ - value for hidden input
    # * +:allow_multiple+ - allow multiple select (add "[]" to checkbox name)
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def radio(method, options={})
      Element::RadioInput.new(self, method, options).generate
    end
    
    # == Number field
    #
    # Generate number field with input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.number(:age)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_age" id="user_age_label">Age</label>
    #     <input class="input" id="user_age" name="user[age]" type="number" />
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
    # * +:min+ - min value
    # * +:max+ - max value
    # * +:in+ - range between minimum and maximum
    # * +:step+ - step between values
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
    def number(method, options={})
      Element::NumberInput.new(self, method, options.merge(:as => :number)).generate
    end
    
    #  == Range field
    #
    # Generate range field with input elements.
    #
    # == Example:
    #
    #   case_form_for(@user) do |f|
    #     f.range(:height)
    #   end
    #
    #   <div class="inputs">
    #     <label class="label" for="user_height" id="user_height_label">Height</label>
    #     <input class="input" id="user_height" name="user[height]" type="range" />
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
    # * +:min+ - min value
    # * +:max+ - max value
    # * +:in+ - range between minimum and maximum
    # * +:step+ - step between values
    # * +:readonly+ - read-only input
    # * +:disabled+ - disable input
    #
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
        when "_destroy" then :checkbox
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