# coding: utf-8
require 'test_helper'

class GeneratorHandleTest < ActionView::TestCase
  #def generator_case_fields_for(object, association, options={})
  #  concat(case_form_for(object) { |f| f.new_object(association, options) })
  #end
  #
  #test "should generate generator link for :belongs_to association" do
  #  puts generator_case_fields_for(@user, :country)
  #  assert_select "fieldset", 1
  #  assert_select "a[data-action=new]", 1
  #end
  
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