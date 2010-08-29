module CaseForm
  module Element
    class Error < Base
      self.allowed_options << [:tag, :as, :connector, :last_connector]
      
      private
        # Defined error HTML tag
        #
        def error_tag
          options.delete(:tag) || CaseForm.error_tag
        end
        
        # Defined error type
        #
        # == Allowed types:
        # * :sentence
        # * :list
        #
        def error_type
          options.delete(:as) || CaseForm.error_type
        end
        
        # Defined error connector (default ', ')
        #
        def error_connector
          options.delete(:connector) || CaseForm.error_connector
        end
        
        # Defined last error connector (default ' and '). Used in sentence with many errors on one method. 
        #
        def last_error_connector
          options.delete(:last_connector) || CaseForm.last_error_connector
        end
        
        # Type of error 
        def error_messages
          list? ? translated_list : translated_sentence
        end
        
        def list?
          error_type == :list
        end
        
        def sentence?
          error_type == :sentence
        end
        
        # OrderedHash with all errors
        def errors
          object.errors
        end
    end
  end
end