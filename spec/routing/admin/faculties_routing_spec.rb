require 'spec_helper'

describe Admin::FacultiesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/faculties", :action => "index", :college_id => "1").should == "/admin/colleges/1/faculties"
    end

    it "maps #new" do
      route_for(:controller => "admin/faculties", :action => "new", :college_id => "1").should == "/admin/colleges/1/faculties/new"
    end

    it "maps #edit" do
      route_for(:controller => "admin/faculties", :action => "edit", :college_id => "1", :id => "1").should == "/admin/colleges/1/faculties/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/faculties", :action => "create", :college_id => "1").should == {:path => "/admin/colleges/1/faculties", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/faculties", :action => "update", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/faculties/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/faculties", :action => "destroy", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/faculties/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/admin/colleges/1/faculties").should == {:controller => "admin/faculties", :action => "index", :college_id => "1"}
    end

    it "generates params for #new" do
      params_from(:get, "/admin/colleges/1/faculties/new").should == {:controller => "admin/faculties", :action => "new", :college_id => "1"}
    end

    it "generates params for #create" do
      params_from(:post, "/admin/colleges/1/faculties").should == {:controller => "admin/faculties", :action => "create", :college_id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/admin/colleges/1/faculties/1/edit").should == {:controller => "admin/faculties", :action => "edit", :college_id => "1", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/admin/colleges/1/faculties/1").should == {:controller => "admin/faculties", :action => "update", :college_id => "1", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/admin/colleges/1/faculties/1").should == {:controller => "admin/faculties", :action => "destroy", :college_id => "1", :id => "1"}
    end
  end
end
