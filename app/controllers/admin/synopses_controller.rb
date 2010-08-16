# -*- coding: utf-8 -*-
class Admin::SynopsesController < Admin::AdminController
  acts_as_helper_content(:model => ::Content::Synopsis)
end
