class Avatar < ActiveRecord::Base
  attr_accessible :image_url, :user
  belongs_to :user
end
