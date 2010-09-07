# Require OpenStruct class
require 'ostruct'
require 'active_model'

class Column
  attr_accessor :name, :type, :null, :default, :limit, :precision, :scale
  
  def initialize(args)
    @name      = args[0]
    @type      = args[1]
    @null      = args[2]
    @default   = args[3]
    @limit     = args[4]
    @precision = args[5]
    @scale     = args[6]
  end
end

class Association < OpenStruct; end

class Country < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  def self.reflect_on_association(attribute)
    attribute == :users ? Association.new(:klass => User, :macro => :has_many) : return
  end
  
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

class User < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  attr_accessor :password_confirmation, :twitter_url, :file_path, :mobile_phone, :birthday_at, :user_zone
  alias_method :birthday_on, :birthday_at
  
  attr_accessor :id
  attr_accessor :country_id # AKA belongs_to :country
  
  undef_method :id
  
  def self.content_columns
    columns = []
    ["firstname", "lastname", "description", "height", "weight", 
      "admin", "login_at", "born_at", "created_at", "updated_at"].each { |c| columns << Column.new([c]) }
    columns
  end
  
  def column_for_attribute(attribute)
    # type, null, default, limit, precision, scale
    args = case attribute.to_sym
    when :id
      [:integer, false]
    when :firstname 
      [:string, true, "Enter firstname", 200]
    when :lastname
      [:string, false, nil, 250]
    when :description 
      [:text, true]
    when (:created_at || :updated_at)
      [:datetime, true]
    when :login_at
      [:timestamp, true]
    when :born_at
      [:date, true]
    when :admin
      [:boolean, false]
    when :height
      [:decimal, false, nil, 10, 5, 3]
    when :weight
      [:float, false]
    when :age
      [:integer, false]
    when :user_zone
      [:string, false]
    end
    Column.new(args.unshift(attribute.to_sym))
  end
  
  def attributes
    instance_variable_get(:@table)
  end
  
  def self.reflect_on_association(attribute)
    macro, klass = case attribute
    when :profile  then [:has_one, Profile]
    when :projects then [:has_many, Project]
    when :country  then [:belongs_to, Country]
    else
      return
    end
    Association.new(:macro => macro, :klass => klass)
  end
  
  def profile
    Profile.new(:user_id => self.id, :id => nil, :email => nil)
  end
  
  def projects
    Project.new(:user_id => self.id, :id => nil, :name => nil)
  end
end

class ValidUser < User
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
  extend ActiveModel::Translation
  
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

class Profile < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  def self.reflect_on_association(attribute)
    attribute == :user ? Association.new(:klass => User, :macro => :belongs_to) : return
  end
  
  def self.content_columns
    columns = []
    ["email"].each { |c| columns << Column.new([c]) }
    columns
  end
  
  def column_for_attribute(attribute)
    # type, null, default, limit, precision, scale
    args = case attribute.to_sym
    when :id
      [:integer, false]
    when :user_id
      [:integer, false]
    when :email 
      [:string, true, nil, 200]
    end
    Column.new(args.unshift(attribute.to_sym))
  end
end

class Project < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  def self.reflect_on_association(attribute)
    attribute == :user ? Association.new(:macro => :belongs_to, :klass => User) : return
  end
  
  def column_for_attribute(attribute)
    # type, null, default, limit, precision, scale
    args = case attribute.to_sym
    when :id
      [:integer, false]
    when :user_id
      [:integer, false]
    when :name 
      [:string, true, nil, 200]
    end
    Column.new(args.unshift(attribute.to_sym))
  end
  
  def self.all
    all = []
    5.times { |i| all << Project.new(:id => i, :name => "Project #{i}") }
    all
  end
  
  def self.extra
    self.all[1..3]
  end
end