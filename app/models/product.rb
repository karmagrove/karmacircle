class Product < ActiveRecord::Base
  belongs_to :user
  mount_uploader :avatar, AvatarUploader
  enum currency: [:usd, :cad, :eur, :gbp]
  #attr_accessor :description, :name, :price, :id, :image_url, :user
  #attr_accessor :image_url
  
  # pass a user
  def get_available_pike13_products(u)
      `curl https://cryozonesm.pike13.com/api/v2/desk/pack_products \
      -H "Authorization: Bearer #{u.pike13token}"`
  end
  
end
