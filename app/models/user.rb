# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include ValidatesAsImage

  has_many :newsitems, :dependent => :destroy

  acts_as_authentic do |c|
    c.merge_validates_length_of_login_field_options :within => 2..100
  end

  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "40x40>" }
  validates_as_image :avatar

  symbolize :gender, :in => [:female, :male, :parquet], :allow_nil => true

  validates_uniqueness_of :login, :email
  belongs_to :college

  def name
    login
  end
end
