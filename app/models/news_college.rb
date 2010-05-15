class NewsCollege < ActiveRecord::Base
  belongs_to :college
  belongs_to :newsitem
end
