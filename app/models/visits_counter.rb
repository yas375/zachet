class VisitsCounter < ActiveRecord::Base
  belongs_to :visitable, :polymorphic => true
end
