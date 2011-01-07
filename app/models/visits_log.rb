class VisitsLog < ActiveRecord::Base
  belongs_to :loggable, :polymorphic => true
  belongs_to :user
end
