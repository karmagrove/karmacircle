class CommunitiesController < ApplicationController


def index
  @users = User.where(:public_profile => true)
end

end