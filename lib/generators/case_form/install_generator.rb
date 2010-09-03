module CaseForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy CaseForm files..."
      source_root File.expand_path('../templates', __FILE__)
      class_option :config, :type => :boolean, :default => true, :desc => "Include CaseForm config file..."
      class_option :stylesheets, :type => :boolean, :default => true, :desc => "Include stylesheet files..."
      class_option :javascripts, :type => :string, :default => :jquery, :desc => "Include javascript files..."
      class_option :locales, :type => :array, :default => [:pl, :en], :desc => "Include locale files..."
      
      def copy_config
        copy_file "case_form.rb", "config/initializers/case_form.rb"
      end
      
      def copy_stylesheets
        if options.stylesheets?
          copy_file "stylesheets/stylesheet.css", "public/stylesheets/case_form.css"
          copy_file "stylesheets/stylesheet_changes.css", "public/stylesheets/case_form_changes.css"
        end
      end
      
      def copy_javascripts
        copy_file "javascripts/#{options.javascripts}.case_form.js", "public/javascripts/case_form.js"
      end
      
      def copy_locales
        options.locales.each do |l|
          copy_file "locales/#{l}.yml", "config/locales/case_form/#{l}.yml"
        end
      end
    end
  end
end