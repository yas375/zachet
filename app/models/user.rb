class User < ActiveRecord::Base
  acts_as_authentic

  symbolize :gender, :in => [:female, :male, :parquet], :allow_nil => true

  validates_uniqueness_of :login, :email
  belongs_to :college

  def name
    login
  end
end
