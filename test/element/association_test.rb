# coding: utf-8
require 'test_helper'

class AssociationTest < ActionView::TestCase
  test "should generate nasted inputs for one to one association with block" do
    concat(case_form_for(@user) { |f| f.association(:country) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 1
    assert_select "input[type=text]", 1
  end
  
  test "should generate nasted inputs for one to one association without block and defined :accept_* method" do
    concat(case_form_for(@user) { |f| f.association(:country) })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 1
    assert_select "input[type=text]", 1
  end
  
  test "should generate nasted inputs for collection association with block" do
    concat(case_form_for(@user) { |f| f.association(:projects) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "input[type=text]", 2 # 2 Projects in collection
  end
  
  test "should generate nasted inputs for collection association without block and defined :accept_* method" do
    concat(case_form_for(@user) { |f| f.association(:projects) })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "input[type=text]", 4 # 2x name, address in Projects in collection
  end
  
  test "should generate input for association with block and not defined :accept_* method" do
    concat(case_form_for(@user) { |f| f.association(:special_projects) })
    assert_select "fieldset", 0
    assert_select "input[type=checkbox]", 5
  end
  
  test "should generate input for association with :as option" do
    concat(case_form_for(@user) { |f| f.association(:country, :as => :select) })
    assert_select "fieldset", 0
    assert_select "select", 1
  end
  
  test "shouldn generate input for association with :as and block" do
    concat(case_form_for(@user) { |f| f.association(:country, :as => :select) { |c| c.attribute :name } })
    assert_select "fieldset", 0
    assert_select "select", 1
  end
  
  test "shouldn't generate nested inputs for association with block and not defined :accept_* method" do
    assert_raise(NoMethodError) { concat(case_form_for(@user) { |f| f.association(:special_projects) { |c| c.attribute(:name) } }) }
  end
  
  test "shouldn't generate nested inputs for non association" do
    assert_raise(ArgumentError) { concat(case_form_for(@user) { |f| f.association(:firstname) { |c| c.attribute(:name) } }) }
  end
  
  test "should generate nasted inputs for association with remove links from model options" do
    puts concat(case_form_for(@user) { |f| f.association(:projects) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "a[data-action=remove]", 2
  end
  
  test "should generate nasted inputs for association without remove links from model options" do
    concat(case_form_for(@user) { |f| f.association(:des_projects) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "a[data-action=remove]", 0
  end
  
  test "should generate nasted inputs for association without remove links" do
    concat(case_form_for(@user) { |f| f.association(:projects, :allow_destroy => false) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "a[data-action=remove]", 0
  end
  
  test "should generate nasted inputs for association with remove links and specified text" do
    concat(case_form_for(@user) { |f| f.association(:projects, :destroy_text => "Usun") { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "a[data-action=remove]", :count => 2, :text => 'Usun'
  end
  
  test "should generate nasted inputs for one to one association without remove links from model options" do
    concat(case_form_for(@user) { |f| f.association(:country) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 1
    assert_select "a[data-action=remove]", 0
  end
  
  test "should generate nasted inputs for association with add link" do
    concat(case_form_for(@user) { |f| f.association(:projects) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "a[data-action=add]", 1
  end
  
  test "should generate nasted inputs for one to one association without add link" do
    concat(case_form_for(@user) { |f| f.association(:country) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 1
    assert_select "a[data-action=add]", 0
  end
  
  test "should generate nasted inputs for one to one association without add link on options" do
    concat(case_form_for(@user) { |f| f.association(:country, :allow_create => true) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 1
    assert_select "a[data-action=add]", 0
  end
  
  test "should generate nasted inputs for association without add link" do
    concat(case_form_for(@user) { |f| f.association(:projects, :allow_create => false) { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "a[data-action=add]", 0
  end
  
  test "should generate nasted inputs for one to one association with add link and text" do
    concat(case_form_for(@user) { |f| f.association(:projects, :create_text => "Dodaj") { |c| c.attribute(:name) } })
    assert_select "fieldset", 1
    assert_select "div.association_inputs", 2
    assert_select "a[data-action=add]", "Dodaj"
  end
end