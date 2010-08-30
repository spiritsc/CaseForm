# coding: utf-8
module CaseForm
  module SentenceError
    # Returns all the full error messages as a sentences in an array.
    #
    #   class User
    #     validates_presence_of :password, :address, :email
    #     validates_length_of :password, :in => 5..30
    #     validates_confirmation_of :password
    #   end
    #
    #   user = User.create(:address => '123 First St.')
    #   user.errors.full_sentences # =>
    #     ["Password is too short (minimum is 5 characters), can't be blank and should match confirmation"]
    #
    def full_sentences(options={})
      full_sentences = []

      keys.each do |attribute|
        if attribute == :base
          self[attribute].each {|m| full_sentences << m }
        else
          attr_name = attribute.to_s.gsub('.', '_').humanize
          attr_name = @base.class.human_attribute_name(attribute, :default => attr_name)

          messages = Array.wrap(self[attribute])
          messages.collect! { |m| I18n.t(:"errors.format", :message => m, :attribute => nil).strip }

          full_sentences << (attr_name + " " + messages.to_sentence(options))
        end
      end

      full_sentences
    end
  end
end

ActiveModel::Errors.send :include, CaseForm::SentenceError