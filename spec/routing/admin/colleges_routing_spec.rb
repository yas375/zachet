require 'spec_helper'

describe Admin::CollegesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/colleges", :action => "index").should == "/admin/colleges"
    end

    it "maps #new" do
      route_for(:controller => "admin/colleges", :action => "new").should == "/admin/colleges/new"
    end

    it "maps #show" do
      route_for(:controller => "admin/colleges", :action => "show", :id => "1").should == "/admin/colleges/1"
    end

    it "maps #edit" do
      route_for(:controller => "admin/colleges", :action => "edit", :id => "1").should == "/admin/colleges/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/colleges", :action => "create").should == {:path => "/admin/colleges", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/colleges", :action => "update", :id => "1").should == {:path =>"/admin/colleges/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/colleges", :action => "destroy", :id => "1").should == {:path =>"/admin/colleges/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/admin/colleges").should == {:controller => "admin/colleges", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/admin/colleges/new").should == {:controller => "admin/colleges", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/admin/colleges").should == {:controller => "admin/colleges", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/admin/colleges/1").should == {:controller => "admin/colleges", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/admin/colleges/1/edit").should == {:controller => "admin/colleges", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/admin/colleges/1").should == {:controller => "admin/colleges", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/admin/colleges/1").should == {:controller => "admin/colleges", :action => "destroy", :id => "1"}
    end
  end
end
