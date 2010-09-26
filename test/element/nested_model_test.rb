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
    assert_select "div.country_association_inputs", 1
    assert_select "input[type=text]", 1
  end
  
  test "should generate nasted inputs for :belongs_to association without block and defined :accept_* method" do
    concat(case_form_for(@user) { |f| f.belongs_to(:country) })
    assert_select "fieldset", 1
    assert_select "div.country_association_inputs", 1
    assert_select "input[type=text]", 2
  end
  
  test "shouldn't generate nested inputs for :belongs_to association without defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.belongs_to(:special_country) { |c| c.attribute(:name) } }) }
  end
  
  # :has_one association
  test "should generate nasted inputs for :has_one association" do
    concat(case_form_for(@user) { |f| f.has_one(:profile) })
    assert_select "fieldset", 1
    assert_select "div.profile_association_inputs", 1
    assert_select "input[type=email]", 1
  end
  
  test "should generate nasted inputs for :has_one association with block" do
    concat(case_form_for(@user) { |f| f.has_one(:profile) { |p| p.attribute(:email) } })
    assert_select "fieldset", 1
    assert_select "div.profile_association_inputs", 1
    assert_select "input[type=email]", 1
  end
  
  test "shouldn't generate nested inputs for :has_one association without defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.has_one(:special_profile) { |c| c.attribute(:email) } }) }
  end
  
  test "shouldn't generate association input for :has_one association" do
    assert_raise(ArgumentError) { concat(case_form_for(@user) { |f| f.has_one(:profile, :as => :select) }) }
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
    assert_select "fieldset", 1
    assert_select "div.projects_association_inputs", 2 # 2 Projects in collection
    assert_select "input[type=text]", 2
  end
  
  test "should generate nasted inputs for :has_many association without block and defined :accept_* method" do
    concat(case_form_for(@user) { |f| f.has_many(:projects) })
    assert_select "fieldset", 1
    assert_select "div.projects_association_inputs", 2 # 2 Projects in collection
    assert_select "input[type=text]", 4 # 2x name, address in Projects in collection
  end
  
  test "shouldn't generate nested inputs for :has_many association without defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.belongs_to(:special_projects) { |c| c.attribute(:name) } }) }
  end
  
  # rest
  
  # test "should generate nasted inputs for association with remove links from model options" do
  #   puts concat(case_form_for(@user) { |f| f.association(:projects) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 2
  #   assert_select "a[data-action=remove]", 2
  # end
  # 
  # test "should generate nasted inputs for association without remove links from model options" do
  #   concat(case_form_for(@user) { |f| f.association(:des_projects) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 2
  #   assert_select "a[data-action=remove]", 0
  # end
  # 
  # test "should generate nasted inputs for association without remove links" do
  #   concat(case_form_for(@user) { |f| f.association(:projects, :allow_destroy => false) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 2
  #   assert_select "a[data-action=remove]", 0
  # end
  # 
  # test "should generate nasted inputs for association with remove links and specified text" do
  #   concat(case_form_for(@user) { |f| f.association(:projects, :destroy_text => "Usun") { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 2
  #   assert_select "a[data-action=remove]", :count => 2, :text => 'Usun'
  # end
  # 
  # test "should generate nasted inputs for one to one association without remove links from model options" do
  #   concat(case_form_for(@user) { |f| f.association(:country) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 1
  #   assert_select "a[data-action=remove]", 0
  # end
  # 
  # test "should generate nasted inputs for association with add link" do
  #   concat(case_form_for(@user) { |f| f.association(:projects) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 2
  #   assert_select "a[data-action=add]", 1
  # end
  # 
  # test "should generate nasted inputs for one to one association without add link" do
  #   concat(case_form_for(@user) { |f| f.association(:country) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 1
  #   assert_select "a[data-action=add]", 0
  # end
  # 
  # test "should generate nasted inputs for one to one association without add link on options" do
  #   concat(case_form_for(@user) { |f| f.association(:country, :allow_create => true) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 1
  #   assert_select "a[data-action=add]", 0
  # end
  # 
  # test "should generate nasted inputs for association without add link" do
  #   concat(case_form_for(@user) { |f| f.association(:projects, :allow_create => false) { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 2
  #   assert_select "a[data-action=add]", 0
  # end
  # 
  # test "should generate nasted inputs for one to one association with add link and text" do
  #   concat(case_form_for(@user) { |f| f.association(:projects, :create_text => "Dodaj") { |c| c.attribute(:name) } })
  #   assert_select "fieldset", 1
  #   assert_select "div.association_inputs", 2
  #   assert_select "a[data-action=add]", "Dodaj"
  # end
end