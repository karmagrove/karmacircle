class Product < ActiveRecord::Base
  belongs_to :user
  has_many :purchases
  # belongs_to :charity
  mount_uploader :avatar, AvatarUploader
  enum currency: [:usd, :cad, :eur, :gbp]
  #attr_accessor :description, :name, :price, :id, :image_url, :user
  #attr_accessor :image_url

  def find_upsell
    return nil unless self.upsell
    return Product.find self.upsell
  end

  def selected_charity(u={})
    if self.charity_choice == true and self.charity then
      return self.charity 
    end
    if self.user
      charity ||= self.user.charity_users.last.charity_id
    else
      charity = u.charity_users.last.charity_id
    end
    charity
  end

  # pass a user
  def get_available_pike13_products(pikeproducts=[],page=1, user)

      # user = self.user
      # user ||=current_user
      user = user
      response = `curl https://#{user.pike13subdomain}.pike13.com/api/v2/desk/pack_products?page=#{page} \
      -H "Authorization: Bearer #{user.pike13token}"`

      # response = `curl https://#{p.user.pike13subdomain}.pike13.com/api/v2/desk/pack_products?page=1 \
      # -H "Authorization: Bearer #{p.user.pike13token}"`

      # response = `curl https://#{p.user.pike13subdomain}.pike13.com/api/v2/desk/pack_products?page=#{page} \
      # -H "Authorization: Bearer #{p.user.pike13token}"`

      response = JSON.parse(response)

      if response and response["pack_products"] then 
        pikeproducts += response["pack_products"].map {|product| [product["product"]["name"], product["id"]]}
        if response["next"]
          get_available_pike13_products(pikeproducts,response["next"].split('=').last, user)
        else 
          return pikeproducts
        end
      else
        return '[{"name": "no products found"}]'
      end
  end

  def list_available_charities

    char = self.user.charity_users
    response = char.map {|p| 
      OpenStruct.new({:charity_id => p.charity_id,:charity_name => p.charity.name, :charity_description => p.charity.description, :charity_url => p.charity.url} )
    }
    response
  end
  
end
