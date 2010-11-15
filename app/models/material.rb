class Material < ActiveRecord::Base
  belongs_to :author
  belongs_to :discipline
  belongs_to :data, :polymorphic => true
end
