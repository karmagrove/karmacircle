class CommunitiesController < ApplicationController


def index
  @users= User.find_by_sql("SELECT u.email, u.name, u.website, u.business_name, u.donation_rate, u.id,u.public_profile, u.avatar, u.community_profile FROM users u WHERE u.public_profile is not null or u.community_profile is not null")
  # @users = User.where(:public_profile => true)
  # @users = @users + User.where(:community_profile => true)
end

end