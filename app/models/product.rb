class Product < ActiveRecord::Base
  belongs_to :user
  mount_uploaders :avatars, AvatarUploader
  #attr_accessor :description, :name, :price, :id, :image_url, :user
  #attr_accessor :image_url
  
end
