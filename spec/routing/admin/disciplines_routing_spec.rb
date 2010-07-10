require 'spec_helper'

describe Admin::DisciplinesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/disciplines", :action => "index", :college_id => "1").should == "/admin/colleges/1/disciplines"
    end

    it "maps #new" do
      route_for(:controller => "admin/disciplines", :action => "new", :college_id => "1").should == "/admin/colleges/1/disciplines/new"
    end

    it "maps #edit" do
      route_for(:controller => "admin/disciplines", :action => "edit", :college_id => "1", :id => "1").should == "/admin/colleges/1/disciplines/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/disciplines", :action => "create", :college_id => "1").should == {:path => "/admin/colleges/1/disciplines", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/disciplines", :action => "update", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/disciplines/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/disciplines", :action => "destroy", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/disciplines/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/admin/colleges/1/disciplines").should == {:controller => "admin/disciplines", :action => "index", :college_id => "1"}
    end

    it "generates params for #new" do
      params_from(:get, "/admin/colleges/1/disciplines/new").should == {:controller => "admin/disciplines", :action => "new", :college_id => "1"}
    end

    it "generates params for #create" do
      params_from(:post, "/admin/colleges/1/disciplines").should == {:controller => "admin/disciplines", :action => "create", :college_id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/admin/colleges/1/disciplines/1/edit").should == {:controller => "admin/disciplines", :action => "edit", :college_id => "1", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/admin/colleges/1/disciplines/1").should == {:controller => "admin/disciplines", :action => "update", :college_id => "1", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/admin/colleges/1/disciplines/1").should == {:controller => "admin/disciplines", :action => "destroy", :college_id => "1", :id => "1"}
    end
  end
end
