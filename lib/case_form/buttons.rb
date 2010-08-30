# coding: utf-8
module CaseForm
  module Buttons
    # == Block with or for buttons
    # 
    # With no arguments it creates fieldset with buttons defined in CaseForm config 
    # (by default :submit and :reset button). Also can create buttons determined in
    # arguments.
    #
    # == Buttons config
    # 
    # * CaseForm.form_buttons
    # * CaseForm.wrapper_tag
    #
    # == Examples:
    #
    #   # Create buttons defined in CaseForm config
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.buttons %>
    #   <% end %>
    #
    #   <div class="fieldset">
    #     <div class="buttons">
    #       <input name="submit" type="submit" value="Create" />
    #     </div>
    #     <div class="buttons">
    #       <input name="reset" type="reset" value="Reset" />
    #     </div>
    #   </div>
    #   
    #   # or create buttons defined in arguments
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.buttons(:commit) %>
    #   <% end %>
    #
    #   <div class="fieldset">
    #     <div class="buttons">
    #       <input name="submit" type="submit" value="Create" />
    #     </div>
    #   </div>
    #   
    #   # or create buttons in block
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.buttons do %>
    #       <%= f.button %>
    #     <% end %>
    #   <% end %>
    #
    #   <div class="fieldset">
    #     <div class="buttons">
    #       <input name="submit" type="submit" value="Create" />
    #     </div>
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:text+ - legend for fieldset
    # For more advanced options for each button use block.
    #
    def buttons(*args, &block)
      options = args.extract_options!
      
      fieldset = Element::Fieldset.new(self, options)
      
      if block_given?
        fieldset.generate(&block)
      else
        args = CaseForm.form_buttons if args.empty?
        fieldset.generate(args.collect { |button| send(button) })
      end
    end
    
    # == Submit button
    #
    # Creates a basic form submit button.
    # 
    # == Examples:
    #
    #   # Generate only button
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.button
    #   <% end %>
    #
    #   <div class="buttons">
    #     <input name="submit" type="submit" value="Create" />
    #   </div>
    #
    #   # or in buttons block
    # 
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.buttons do %>
    #       <%= f.button %>
    #     <% end %>
    #   <% end %>
    #
    #   <div class="fieldset">
    #     <div class="buttons">
    #       <input name="submit" type="submit" value="Create" />
    #     </div>
    #   </div>
    # 
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:text+ - text on button
    # * +:disabled+ - disabled button
    # * +:as+ - button type (supported values: :submit and :reset)
    #
    # == I18n lookups priority:
    #
    # * 'case_form.buttons.{{model}}.{{button_type}}'
    # * 'case_form.buttons.{{button_type}}'
    # * Create || Update
    #
    def button(options={})
      Element::Button.new(self, options.merge(:as => :submit)).generate
    end
    alias_method :commit, :button
    
    # == Reset button
    #
    # Creates a new reset button for forms (support for HTML5).
    #
    # == Examples:
    #
    #   # Generate only button
    #
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.reset
    #   <% end %>
    #
    #   <div class="buttons">
    #     <input name="reset" type="reset" value="Reset" />
    #   </div>
    #
    #   # or in buttons block
    # 
    #   <%= case_form_for(@user) do |f| %>
    #     <%= f.buttons do %>
    #       <%= f.reset %>
    #     <% end %>
    #   <% end %>
    #
    #   <div class="fieldset">
    #     <div class="buttons">
    #       <input name="reset" type="reset" value="Reset" />
    #     </div>
    #   </div>
    #
    # == Allowed options:
    # * +:id+ - HTML ID
    # * +:class+ - HTML class
    # * +:style+ - not recommended HTML styles (use CSS)
    # * +:text+ - text on button
    # * +:disabled+ - disabled button
    # * +:as+ - button type (supported values: :submit and :reset)
    #
    # == I18n lookups priority:
    #
    # * 'case_form.buttons.{{model}}.{{button_type}}'
    # * 'case_form.buttons.{{button_type}}'
    # * Reset
    #
    def reset(options={})
      Element::Button.new(self, options.merge(:as => :reset)).generate
    end
  end
end