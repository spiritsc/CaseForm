# coding: utf-8
module CaseForm
  module Buttons
    # Generate block for or with buttons.
    # 
    # With no arguments it creates fieldset with buttons defined in CaseForm config 
    # (by default :submit and :reset button). Also can create buttons determined in
    # arguments.
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
    # * :id - HTML ID
    # * :class - HTML class
    # * :style - not recommended HTML styles (use CSS)
    # * :text - legend for fieldset
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
    
    # Generate commit button
    def button(options={})
      Element::Button.new(self, options.merge(:as => :submit)).generate
    end
    alias_method :commit, :button
    
    # Generate reset button
    def reset(options={})
      Element::Button.new(self, options.merge(:as => :reset)).generate
    end
  end
end