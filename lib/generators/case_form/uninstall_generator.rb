module CaseForm
  module Generators
    class UninstallGenerator < Rails::Generators::Base
      desc "Delete all CaseForm files..."
      class_option :config,      :type => :boolean, :default => true, :desc => "Delete CaseForm config file..."
      class_option :stylesheets, :type => :boolean, :default => true, :desc => "Delete stylesheet files..."
      class_option :javascripts, :type => :boolean, :default => true, :desc => "Delete javascript files..."
      class_option :locales,     :type => :boolean, :default => true, :desc => "Delete locale files..."
      
      def delete_config
        remove_file "config/initializers/case_form.rb" if options.config?
      end
      
      def delete_stylesheets
        if options.stylesheets?
          remove_file "public/stylesheets/case_form.css"
          remove_file "public/stylesheets/case_form_changes.css"
        end
      end
      
      def delete_javascripts
        remove_file "public/javascripts/case_form.js" if options.javascripts?
      end
      
      def delete_locales
        remove_file "config/locales/case_form" if options.locales?
      end
    end
  end
end