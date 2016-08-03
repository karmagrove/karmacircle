class Product < ActiveRecord::Base
  belongs_to :user
  mount_uploader :avatar, AvatarUploader
  #attr_accessor :description, :name, :price, :id, :image_url, :user
  #attr_accessor :image_url
  
end
