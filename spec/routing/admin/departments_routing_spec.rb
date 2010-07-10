require 'spec_helper'

describe Admin::DepartmentsController do
  describe "route generation" do
    it "maps #new" do
      route_for(:controller => "admin/departments", :action => "new", :college_id => "1").should == "/admin/colleges/1/departments/new"
    end

    it "maps #edit" do
      route_for(:controller => "admin/departments", :action => "edit", :college_id => "1", :id => "1").should == "/admin/colleges/1/departments/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/departments", :action => "create", :college_id => "1").should == {:path => "/admin/colleges/1/departments", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/departments", :action => "update", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/departments/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/departments", :action => "destroy", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/departments/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #new" do
      params_from(:get, "/admin/colleges/1/departments/new").should == {:controller => "admin/departments", :action => "new", :college_id => "1"}
    end

    it "generates params for #create" do
      params_from(:post, "/admin/colleges/1/departments").should == {:controller => "admin/departments", :action => "create", :college_id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/admin/colleges/1/departments/1/edit").should == {:controller => "admin/departments", :action => "edit", :college_id => "1", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/admin/colleges/1/departments/1").should == {:controller => "admin/departments", :action => "update", :college_id => "1", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/admin/colleges/1/departments/1").should == {:controller => "admin/departments", :action => "destroy", :college_id => "1", :id => "1"}
    end
  end
end
