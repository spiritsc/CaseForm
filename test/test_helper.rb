require 'rubygems'
require 'test/unit'

gem 'actionpack', '3.0.0'
gem 'activemodel', '3.0.0'

require 'active_model'
require 'action_controller'
require 'action_view'
require 'action_view/template'

# Require CaseForm
$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'case_form'

# Require at last
require 'action_view/test_case'

# Require fake objects
require 'lib/models'

class ActionView::TestCase
  setup do
    generate_virtual_models
  end
  
  # Generate fake models
  def generate_virtual_models
    @user = User.new(
      :id => 1, 
      :firstname => "John", 
      :lastname => "Doe", 
      :email => "john@doe.com", 
      :admin => true, 
      :description => "User note", 
      :age => 18, 
      :height => 188, 
      :weight => 82.5)
    @valid_user = ValidUser.new({
      :id => 1, 
      :firstname => "John", 
      :lastname => "Doe", 
      :email => "john@doe.com", 
      :admin => true, 
      :height => 188})
    @invalid_user = InvalidUser.new({
      :id => 1,
      :firstname => "J"})
    
    @country = Country.new({:id => 1, :name => "Poland", :continent => "Europe"})
    @profile = Profile.new({:user_id => 1, :id => 1, :email => "example@mail.com", :twitter => @example})
    @projects = []
    2.times { |i| @projects << Project.new({:user_id => 1, :id => i, :name => "Project #{i}", :address => "Address #{i}"}) }
    
    @user.country = @country
    @user.profile = @profile
    @user.projects = @projects
  end
  
  def cf_config(key)
    CaseForm.send(key)
  end
  
  # Define some routes path
  def users_path(*args); '/users'; end
  alias_method :users_url, :users_path
  alias_method :valid_users_path, :users_path
  alias_method :invalid_users_path, :users_path
  
  def user_path(user); "/users/#{user.to_param}"; end
  alias_method :user_url, :user_path
  alias_method :valid_user_path, :user_path
  alias_method :invalid_user_path, :user_path
end