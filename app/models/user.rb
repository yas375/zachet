# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include ValidatesAsImage

  acts_as_authentic do |c|
    c.merge_validates_length_of_login_field_options :within => 2..100
    c.transition_from_crypto_providers = Authlogic::CryptoProviders::MD5
  end

  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "40x40>" }
  validates_as_image :avatar

  has_many :newsitems, :dependent => :nullify, :foreign_key => 'author_id'
  has_many :teachers, :dependent => :nullify, :foreign_key => 'author_id'
  has_many :topics, :dependent => :nullify, :foreign_key => 'author_id'
  has_many :posts, :dependent => :nullify, :foreign_key => 'author_id'
  has_many :comments, :dependent => :nullify, :foreign_key => 'author_id'
  has_many :visits, :class_name => 'VisitsLog', :dependent => :nullify

  symbolize :gender, :in => [:female, :male, :parquet], :allow_nil => true

  validates_uniqueness_of :login, :email
  belongs_to :college

  def full_name
    ''.tap do |a|
      a << first_name if first_name
      a << " " if first_name && last_name
      a << last_name if last_name
    end
  end

  def name
    login
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    # TODO send message
    # edit_password_reset_url(user.perishable_token, :email => user.email)
    Rails.logger.debug "perishable_token: #{perishable_token}"
  end
end
