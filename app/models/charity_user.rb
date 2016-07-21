class CharityUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :charity
  enum role: [:supporter, :admin]
  
  
end
