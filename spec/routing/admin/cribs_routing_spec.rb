require 'spec_helper'

describe Admin::CribsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/cribs", :action => "index", :college_id => "1").should == "/admin/colleges/1/cribs"
    end

    it "maps #new" do
      route_for(:controller => "admin/cribs", :action => "new", :college_id => "1").should == "/admin/colleges/1/cribs/new"
    end

    it "maps #edit" do
      route_for(:controller => "admin/cribs", :action => "edit", :college_id => "1", :id => "1").should == "/admin/colleges/1/cribs/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "admin/cribs", :action => "create", :college_id => "1").should == {:path => "/admin/colleges/1/cribs", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "admin/cribs", :action => "update", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/cribs/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "admin/cribs", :action => "destroy", :college_id => "1", :id => "1").should == {:path =>"/admin/colleges/1/cribs/1", :method => :delete}
    end
  end
end
