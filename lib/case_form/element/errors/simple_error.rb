module CaseForm
  module Element
    class SimpleError < Error
      include ElementExt::Associationable
      
      attr_accessor :method
      
      # Initialize error object
      # 
      def initialize(builder, method, options={})
        @method = method
        super(builder, options)
      end
      
      # Generate simple errors for method with HTML options
      #
      def generate
        template.content_tag error_tag, error_messages, html_options
      end
        
      private
        # Distribute default options for simple error.
        #
        def default_options
          options[:class] ||= [:error]
          options[:id]    ||= "#{object_name}_#{method}_error"
        end
        
        # Return all errors on method. If method is association than it takes also errors on association.
        # == Example:
        #   
        #   # Get errors both on :country and :country_id attribute
        #
        #   class User
        #     belongs_to :country
        #     validates_presence_of :country_id
        #     validates_inclusion_of :country, :in => Country.priority
        #   end
        #
        def method_errors
          association ? errors[method] + errors[association_method] : errors[method]
        end
        
        # Error messages as list.
        #
        # == Example:
        #
        #   # object.errors[:name] = ['can't be blank', 'should be uniq']
        #
        #   <ul>
        #     <li>can't be blank</li>
        #     <li>should be uniq</li>
        #   </ul>
        #
        def translated_list
          template.content_tag :ul, (method_errors.collect { |msg| template.content_tag :li, msg }).join.html_safe
        end
        
        # Error messages as sentence.
        #
        # == Example:
        #
        #   # object.errors[:name] = ['can't be blank', 'should be uniq']
        #
        #   <div>
        #     can't be blank and should be uniq
        #   </div>
        #
        def translated_sentence
          method_errors.to_sentence(:words_connector     => error_connector, 
                                    :last_word_connector => last_error_connector,
                                    :two_words_connector => last_error_connector)
        end
    end
  end
end