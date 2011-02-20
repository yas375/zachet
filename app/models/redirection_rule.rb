class RedirectionRule < ActiveRecord::Base
  belongs_to :object, :polymorphic => true

  validates_uniqueness_of :old_path, :scope => :subdomain
end
