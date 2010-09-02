# Require OpenStruct class
require 'ostruct'
require 'active_model'

class Column
  attr_accessor :type, :null, :default, :limit, :precision, :scale
  
  def initialize(args)
    @type      = args[0]
    @null      = args[1]
    @defalut   = args[2]
    @limit     = args[3]
    @precision = args[4]
    @scale     = args[5]
  end
end

class Association < OpenStruct; end

class Country < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  def self.reflect_on_association(attribute = :users)
    Association.new(:klass => User, :macro => :has_many)
  end
  
  def self.all
    [Country.new(:id => 1, :name => "Poland"), 
     Country.new(:id => 2, :name => "Germany"),
     Country.new(:id => 3, :name => "France"),
     Country.new(:id => 4, :name => "Spain"),
     Country.new(:id => 5, :name => "US")]
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
  
  attr_accessor :id, :country_id
  
  undef_method :id
  
  def self.column_names
    ["id", "firstname", "lastname", "description", "height", "weight", 
      "admin", "login_at", "born_at", "created_at", "updated_at"]
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
    Column.new(args)
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
  
  def self.reflect_on_association(attribute = :user)
    Association.new(:klass => User, :macro => :belongs_to)
  end
end

class Project < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  def self.reflect_on_association(attribute = :user)
    Association.new(:macro => :belongs_to, :klass => User)
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