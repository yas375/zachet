require 'spec_helper'

describe Admin::CollegesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/teachers", :action => "index").should == "/admin/teachers"
    end

    it "maps #new" do
      route_for(:controller => "admin/teachers", :action => "new").should == "/admin/teachers/new"
    end

    it "maps #show" do
      route_for(:controller => "admin/teachers", :action => "show", :id => "1").should == "/admin/teachers/1"
    end

    it "maps #edit" do
      route_for(:controller => "admin/teachers", :action => "edit", :id => "1").should == "/admin/teachers/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/teachers", :action => "create").should == {:path => "/admin/teachers", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/teachers", :action => "update", :id => "1").should == {:path =>"/admin/teachers/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/teachers", :action => "destroy", :id => "1").should == {:path =>"/admin/teachers/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/admin/teachers").should == {:controller => "admin/teachers", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/admin/teachers/new").should == {:controller => "admin/teachers", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/admin/teachers").should == {:controller => "admin/teachers", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/admin/teachers/1").should == {:controller => "admin/teachers", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/admin/teachers/1/edit").should == {:controller => "admin/teachers", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/admin/teachers/1").should == {:controller => "admin/teachers", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/admin/teachers/1").should == {:controller => "admin/teachers", :action => "destroy", :id => "1"}
    end
  end
end
