class Product < ActiveRecord::Base
  belongs_to :user
  has_many :purchases
  mount_uploader :avatar, AvatarUploader
  enum currency: [:usd, :cad, :eur, :gbp]
  #attr_accessor :description, :name, :price, :id, :image_url, :user
  #attr_accessor :image_url
  
  # pass a user
  def get_available_pike13_products()
      response = `curl https://thecryozone.pike13.com/api/v2/desk/pack_products \
      -H "Authorization: Bearer #{self.user.pike13token}"`
      response = JSON.parse(response)
      if response and response["pack_products"] then 
        

        pikeproducts = response["pack_products"].map {|product| [product["product"]["name"], product["id"]]}
        return ["",""] + pikeproducts
        return ()
      else
        return '[{"name": "no products found"}]'
      end
  end
  
end
