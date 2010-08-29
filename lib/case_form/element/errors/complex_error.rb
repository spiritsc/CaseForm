module CaseForm
  module Element
    class ComplexError < Error
      self.allowed_options << [:header_tag, :header_message, :message_tag, :message]
      
      # Generate all error messages as HTML <ul> list with optional header and message.
      # 
      def generate
        contents = []
        contents << template.content_tag(header_tag, header_message) if header_message
        contents << template.content_tag(message_tag, message)       if message
        contents << template.content_tag(:ul, error_messages)
        
        template.content_tag(error_tag, contents.join.html_safe, html_options)
      end
      
      private
        # Distribute default options for complex errors.
        #
        def default_options
          options[:class] ||= [:errors]
          options[:id]    ||= "#{object_name}_errors"
        end
        
        # Error messages as list.
        #
        # == Example:
        #
        #   # object.errors = { :name => ['can't be blank', 'should be uniq'],
        #                       :price => 'should be more than 10' }
        #
        #   <ul>
        #     <li>Name can't be blank</li>
        #     <li>Name should be uniq</li>
        #     <li>Price should be more than 10</li>
        #   </ul>
        #                 
        def translated_list
          (errors.full_messages.collect { |msg| template.content_tag :li, msg }).join.html_safe
        end
        
        # Error messages as sentence.
        #
        # == Example:
        #
        #   # object.errors = { :name => ['can't be blank', 'should be uniq'],
        #                       :price => 'should be more than 10' }
        #
        #   <ul>
        #     <li>Name can't be blank and should be uniq</li>
        #     <li>Price should be more than 10</li>
        #   </ul>
        #
        def translated_sentence
          (errors.full_sentences(:words_connector     => error_connector, 
                                 :last_word_connector => last_error_connector,
                                 :two_words_connector => last_error_connector).collect { |msg| template.content_tag :li, msg }).join.html_safe
        end
        
        # Defined error header message HTML tag.
        #
        def header_tag
          options.delete(:header_tag) || CaseForm.complex_error_header_tag
        end
        
        # Defined error header message from option or I18n.
        #
        def header_message
          options.delete(:header_message) || translated_header_message
        end
        
        # Translated error header message by I18n.
        #
        def translated_header_message
          lookups = []
          lookups << :"activemodel.errors.template.header_message"
          lookups << :"activerecord.errors.template.header_message"
          lookups << :"case_form.errors.template.header_message"
          lookups << "Some errors prohibited this object from being saved"
          I18n.t(lookups.shift, :default => lookups)
        end
        
        # Defined error message HTML tag.
        #
        def message_tag
          options.delete(:message_tag) || CaseForm.complex_error_message_tag
        end
        
        # Defined error message from option or I18n.
        #
        def message
          options.delete(:message) || translated_message
        end
        
        # Translated error message by I18n.
        #
        def translated_message
          lookups = []
          lookups << :"activemodel.errors.template.message"
          lookups << :"activerecord.errors.template.message"
          lookups << :"case_form.errors.template.message"
          lookups << "There were problems with the following fields:"
          I18n.t(lookups.shift, :default => lookups)
        end
    end
  end
end