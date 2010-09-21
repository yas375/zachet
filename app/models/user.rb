class User < ActiveRecord::Base
  acts_as_authentic

  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "40x40>" }

  symbolize :gender, :in => [:female, :male, :parquet], :allow_nil => true

  validates_uniqueness_of :login, :email
  belongs_to :college

  def name
    login
  end
end
