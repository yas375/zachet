class Admin::AdminController < ApplicationController
  extend Admin::Content
  before_filter :require_user
  layout 'admin'
end
