require 'spec_helper'

describe Admin::SynopsesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/synopses", :action => "index", :college_id => "1").should == "/admin/colleges/1/synopses"
    end

    it "maps #new" do
      route_for(:controller => "admin/synopses", :action => "new", :college_id => "1").should == "/admin/colleges/1/synopses/new"
    end

    it "maps #edit" do
      route_for(:controller => "admin/synopses", :action => "edit", :college_id => "1", :id => "1").should == "/admin/colleges/1/synopses/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/synopses", :action => "create", :college_id => "1").should == {:path => "/admin/colleges/1/synopses", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/synopses", :action => "update", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/synopses/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/synopses", :action => "destroy", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/synopses/1", :method => :delete}
    end
  end
end
