module CaseForm
  module Errors
    def error_messages(options={})
      Element::ComplexError.new(self, options).generate if object.errors.any?
    end
    alias_method :error_messages_for, :error_messages
    alias_method :errors_for, :error_messages
    alias_method :errors, :error_messages
    
    def error_message(method, options={})
      Element::SimpleError.new(self, method, options).generate if object.errors[method].any?
    end
    alias_method :error_message_on, :error_message
    alias_method :error_on, :error_message
    alias_method :error, :error_message
  end
end