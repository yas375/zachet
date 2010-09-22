# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_length_of_login_field_options :within => 2..100
  end

  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "40x40>" }
  # TODO check validation message
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/jpg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/bmp']

  symbolize :gender, :in => [:female, :male, :parquet], :allow_nil => true

  validates_uniqueness_of :login, :email
  belongs_to :college

  def name
    login
  end
end
