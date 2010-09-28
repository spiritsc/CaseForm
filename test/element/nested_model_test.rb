# coding: utf-8
require 'test_helper'

class NestedModelTest < ActionView::TestCase
  # non association
  test "shouldn't generate association input for non association method" do
    assert_raise(ArgumentError) { concat(case_form_for(@user) { |f| f.belongs_to(:non_association) }) }
  end
  
  # :belongs_to association
  test "should generate association input for :belongs_to association" do
    concat(case_form_for(@user) { |f| f.belongs_to(:special_country) })
    assert_select "select", 1
  end
  
  test "should generate association input for :belongs_to association with specified input" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country, :as => :radio) })
    assert_select "input[type=radio]", 5
  end
  
  test "should generate nasted inputs for :belongs_to association with block" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select("div.country_association_inputs", 1) { assert_select "input[type=text]", 1 }
  end
  
  test "should generate nasted inputs for :belongs_to association without block and defined :accept_* method" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country) })
    assert_select "fieldset", 1
    assert_select("div.country_association_inputs", 1) { assert_select "input[type=text]", 2 }
  end
  
  test "should generate nasted inputs for :belongs_to association without block and defined :fields option" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country, :fields => :name) })
    assert_select("div.country_association_inputs", 1) { assert_select "input[type=text]", 1 }
  end
  
  test "shouldn't generate nested inputs for :belongs_to association without defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.belongs_to(:special_country) { |c| c.attribute(:name) } }) }
  end
  
  test "should generate nasted inputs for :belongs_to association with empty object and block" do
    @user.country = nil
    concat(case_form_for(@user) { |f| f.belongs_to(:country) { |c| c.attribute(:name) } })
    assert_select("div.country_association_inputs", 1) { assert_select "input[type=text]", 1 }
    @user.country = @country
  end
  
  test "should generate nasted inputs for :belongs_to association with empty object and without block" do
    @user.country = nil
    concat(case_form_for(@user) { |f| f.belongs_to(:country) })
    assert_select("div.country_association_inputs", 1) { assert_select "input[type=text]", 2 }
    @user.country = @country
  end
  
  # :has_one association
  test "should generate nasted inputs for :has_one association" do
    concat(case_form_for(@user) { |f| f.has_one(:profile) })
    assert_select "fieldset", 1
    assert_select "div.profile_association_inputs", 1 do
      assert_select "input[type=email]", 1
      assert_select "input[type=text]", 1
    end
  end
  
  test "should generate nasted inputs for :has_one association with block" do
    concat(case_form_for(@user) { |f| f.has_one(:profile) { |p| p.attribute(:email) } })
    assert_select "fieldset", 1
    assert_select("div.profile_association_inputs", 1) { assert_select "input[type=email]", 1 }
  end
  
  test "should generate nasted inputs for :has_one association without block and with defined :fields option" do
    concat(case_form_for(@user) { |f| f.has_one(:profile, :fields => :twitter) })
    assert_select "div.profile_association_inputs", 1 do
      assert_select "input[type=email]", 0
      assert_select "input[type=text]", 1
    end
  end
  
  test "shouldn't generate nested inputs for :has_one association without defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.has_one(:special_profile) { |c| c.attribute(:email) } }) }
  end
  
  test "shouldn't generate association input for :has_one association" do
    assert_raise(ArgumentError) { concat(case_form_for(@user) { |f| f.has_one(:profile, :as => :select) }) }
  end
  
  test "should generate nasted inputs for :has_one association with empty object and block" do
    @user.profile = nil
    concat(case_form_for(@user) { |f| f.has_one(:profile) { |p| p.attribute(:email) } })
    assert_select("div.profile_association_inputs", 1) { assert_select "input[type=email]", 1 }
    @user.profile = @profile
  end
  
  test "should generate nasted inputs for :has_one association with empty object and without block" do
    @user.profile = nil
    concat(case_form_for(@user) { |f| f.has_one(:profile) })
    assert_select("div.profile_association_inputs", 1) { assert_select "input[type=email]", 1 }
    @user.profile = @profile
  end
  
  # :has_many association
  test "should generate association input for :has_many association" do
    concat(case_form_for(@user) { |f| f.has_many(:special_projects) })
    assert_select "input[type=checkbox]", 5
  end
  
  test "should generate association input for :has_many association with specified input" do
    concat(case_form_for(@user) { |f| f.has_many(:projects, :as => :radio) })
    assert_select "input[type=radio]", 5
  end
  
  test "should generate nasted inputs for :has_many association with block" do
    concat(case_form_for(@user) { |f| f.has_many(:projects) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1 # 2 Projects in collection + 1 new
    assert_select("div.projects_association_inputs", 3) { assert_select "input[type=text]", 3 }
  end
  
  test "should generate nasted inputs for :has_many association without block and defined :accept_* method" do
    concat(case_form_for(@user) { |f| f.has_many(:projects) })
    assert_select "fieldset", 1 # 2 Projects in collection + 1 new
    assert_select("div.projects_association_inputs", 3) { assert_select "input[type=text]", 6 }
  end
  
  test "should generate nasted inputs for :has_many association without block and with defined :fields option" do
    concat(case_form_for(@user) { |f| f.has_many(:projects, :fields => :name) })
    assert_select "fieldset", 1 # 2 Projects in collection + 1 new
    assert_select("div.projects_association_inputs", 3) { assert_select "input[type=text]", 3 }
  end
  
  test "shouldn't generate nested inputs for :has_many association without defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.belongs_to(:special_projects) { |c| c.attribute(:name) } }) }
  end
  
  test "should generate nasted inputs for :has_many association with specified collection" do
    concat(case_form_for(@user) { |f| f.has_many(:projects, :collection => Project.extra) })
    assert_select("div.projects_association_inputs", 4) { assert_select "input[type=text]", 8 }
  end
  
  test "should generate nasted inputs for :has_many association with empty object and block" do
    @user.projects = nil
    concat(case_form_for(@user) { |f| f.has_many(:projects) { |a| a.attribute(:name) } })
    assert_select("div.projects_association_inputs", 1) { assert_select "input[type=text]", 1 }
    @user.projects = @projects
  end
  
  test "should generate nasted inputs for :has_many association with empty object and without block" do
    @user.projects = nil
    concat(case_form_for(@user) { |f| f.has_many(:projects) })
    assert_select("div.projects_association_inputs", 1) { assert_select "input[type=text]", 2 }
    @user.projects = @projects
  end
end