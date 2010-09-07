# Require OpenStruct class
require 'ostruct'
require 'active_model'

class Column
  attr_accessor :name, :type, :null, :default, :limit, :precision, :scale
  
  def initialize(*args)
    @name      = args[0]
    @type      = args[1]
    @null      = args[2]
    @default   = args[3]
    @limit     = args[4]
    @precision = args[5]
    @scale     = args[6]
  end
end

class Association
  attr_accessor :klass, :macro
  
  def initialize(*args)
    @klass = args[0].constantize
    @macro = args[1]
  end
end

class BaseModel < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  class_inheritable_accessor :associations, :all_columns, :all_content_columns
  # columns: type, null, default, limit, precision, scale
  
  def self.reflect_on_association(attribute)
    association = self.associations[attribute.to_sym]
    return unless association
    Association.new(*association)
  end
  
  def self.columns
    columns = []
    self.all_columns.each { |col| columns << Column.new(*col) }
    columns
  end
  
  def self.content_columns
    columns = []
    self.all_content_columns.each { |col| columns << Column.new(*col) }
    columns
  end
  
  def column_for_attribute(attribute)
    args = [attribute.to_sym, self.all_columns[attribute.to_sym]].flatten
    Column.new(*args)
  end
end

class Country < BaseModel
  self.associations = { 
    :users    => ["User", :has_many]
  }
  self.all_columns = {
    :id       => [:integer, false],
    :name     => [:string, false, nil, 250]
  }
  self.all_content_columns = self.all_columns.keys - [:id]
  
  def self.all
    [new(:id => 1, :name => "Poland"), 
     new(:id => 2, :name => "Germany"),
     new(:id => 3, :name => "France"),
     new(:id => 4, :name => "Spain"),
     new(:id => 5, :name => "US")]
  end
  
  def self.priority
    self.all[1..3]
  end
  
  def short
    self.name[0...3]
  end
  
  def non_id
    self.name[0]
  end
end

class User < BaseModel
  self.associations = { 
    :country    => [ "Country", :belongs_to],
    :profile    => [ "Profile", :has_one],
    :projects   => [ "Project", :has_many]
  }
  self.all_columns = {
    :id          => [:integer, false],
    :country_id  => [:integer, false],
    :firstname   => [:string, true, "Enter firstname", 200],
    :lastname    => [:string, false, nil, 250],
    :description => [:text, true],
    :created_at  => [:datetime, true],
    :updated_at  => [:datetime, true],
    :login_at    => [:timestamp, true],
    :born_at     => [:date, true],
    :admin       => [:boolean, false],
    :height      => [:decimal, false, nil, 10, 5, 3],
    :weight      => [:float, false],
    :age         => [:integer, false],
    :user_zone   => [:string, false]
  }
  self.all_content_columns = self.all_columns.keys - [:id, :country_id]
  
  attr_accessor :password_confirmation, :twitter_url, :file_path, :mobile_phone, :birthday_at, :user_zone
  alias_method :birthday_on, :birthday_at
  
  attr_accessor :id
  attr_accessor :country_id # AKA belongs_to :country
  
  undef_method :id
  
  def country
    Country.new(:user_id => self.id, :id => nil, :name => "Poland")
  end
  
  def profile
    Profile.new(:user_id => self.id, :id => nil, :email => nil)
  end
  
  def projects
    Project.new(:user_id => self.id, :id => nil, :name => nil)
  end
end

class ValidUser < User
  self.associations = User.associations
  self.all_columns = User.all_columns
  self.all_content_columns = User.all_content_columns
  
  validates :firstname, :length => {:minimum => 3, :maximum => 40}, :presence => true
  validates :lastname, :email, :presence => true
  
  attr_accessor :valid_height
  validates :valid_height, :length => { :minimum => 0, :maximum => 280 }
  attr_accessor :min_height
  attr_accessor :max_height
  validates :min_height, :length => { :minimum => 0 }
  validates :max_height, :length => { :maximum => 280 }
end

class InvalidUser < User
  self.associations = User.associations
  self.all_columns = User.all_columns
  self.all_content_columns = User.all_content_columns
  
  attr_reader :errors
  
  def initialize(options={})
    super(options)
    @errors = ActiveModel::Errors.new(self)
    @errors.add(:base, "Some base error")
    @errors.add(:firstname, "can't be blank")
    @errors.add(:firstname, "should match confirmation")
    @errors.add(:firstname, "is too short")
    @errors.add(:lastname, "can't be blank")
  end
end

class Profile < BaseModel
  self.associations = { 
    :users    => [ "User", :belongs_to]
  }
  self.all_columns = {
    :id       => [:integer, false],
    :user_id  => [:integer, false],
    :name     => [:string, false, nil, 250]
  }
  self.all_content_columns = self.all_columns.keys - [:id, :user_id]
end

class Project < BaseModel
  self.associations = { 
    :users    => [ "User", :belongs_to ]
  }
  self.all_columns = {
    :id       => [:integer, false],
    :user_id  => [:integer, false],
    :name     => [:string, false, nil, 250]
  }
  self.all_content_columns = self.all_columns.keys - [:id, :user_id]
  
  def self.all
    all = []
    5.times { |i| all << Project.new(:id => i, :name => "Project #{i}") }
    all
  end
  
  def self.extra
    self.all[1..3]
  end
end