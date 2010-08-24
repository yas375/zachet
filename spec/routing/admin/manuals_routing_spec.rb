require 'spec_helper'

describe Admin::ManualsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/manuals", :action => "index", :college_id => "1").should == "/admin/colleges/1/manuals"
    end

    it "maps #new" do
      route_for(:controller => "admin/manuals", :action => "new", :college_id => "1").should == "/admin/colleges/1/manuals/new"
    end

    it "maps #edit" do
      route_for(:controller => "admin/manuals", :action => "edit", :college_id => "1", :id => "1").should == "/admin/colleges/1/manuals/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/manuals", :action => "create", :college_id => "1").should == {:path => "/admin/colleges/1/manuals", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/manuals", :action => "update", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/manuals/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/manuals", :action => "destroy", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/manuals/1", :method => :delete}
    end
  end
end
