class SessionsController < ApplicationController
  def setup_oauth(donation_id="")
    callback_url = "http://localhost:3000/auth/facebook/callback"

    @oauth = Koala::Facebook::OAuth.new(ENV['APP_ID'], ENV['APP_SECRET'], callback_url)
    @url_for_facebook = @oauth.url_for_oauth_code(:state=>donation_id)
  end

  def authenticate_pike13
    @client_id=ENV['CLIENT_ID']
    @client_secret=ENV['CLIENT_SECRET']
    @client = OAuth2::Client.new(@client_id, @client_secret, :site => 'https://frontdeskhq.com/oauth/authorize')  
    url = @client.auth_code.authorize_url(:redirect_uri => 'http://www.karmagrove.com/callback/frontdesk')
    redirect_to url
  end

  def create_pike13

    Rails.logger.info "session create!"
    session[:code] = params['code']
    Rails.logger.info "session code #{params['code']}"
    Rails.logger.info "session[:code] #{session[:code]}"
    Rails.logger.info "session create for user #{user}!"
    Rails.logger.info "params.inspect #{params.inspect}, auth_hash #{auth_hash}"
    #redirect_to '/gas_deliveries'
    redirect_to '/profile'
  end

  def create
    # P_ID=402764733175875;
    # export FACEBOOK_SECRET=b91c8b29bf5295730b4d8100f76ded1d;

    # generate authenticating URL
    setup_oauth
    @code = params[:code]
    Rails.logger.info "code : #{params[:code]}"
    if @code
      Rails.logger.info("@code : #{@code}")
      Rails.logger.info("made it through the if statement!")
      # fetch the access token once you have the code
      # callback_url = "http://localhost:3000/auth/facebook/callback"
      # @oauth = Koala::Facebook::OAuth.new("402764733175875", "b91c8b29bf5295730b4d8100f76ded1d", callback_url)
      # Rails.logger.info @oauth
      # # # code = session['callback_code']
      # Rails.logger.info("code : #{code}")

      @token = @oauth.get_access_token(@code)

      @rest = Koala::Facebook::API.new(@token)

      # graph = Koala::Facebook::GraphAPI.new(access_token)

      # @graph = Koala::Facebook::API.new(oauth_access_token)

      @profile = @rest.get_object("me")
      Rails.logger.info @profile.inspect
      @profile_path = @rest.get_picture(@profile['id'],:type => "large")
      # @name_pic = @rest.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid1 = me())")
      # Rails.logger.info @name_pic

      # @rest.fql_query(my_fql_query) # convenience method

      # @rest.fql_multiquery(fql_query_hash) # convenience method
      # @rest.rest_call("stream.publish", arguments_hash) # generic version

      Rails.logger.info " @token #{@token} and params[:state] #{params[:state]}"
      if params[:state]
      #   @purchase = Purchase.find params[:state]
      #   Rails.logger.info " @profile['id'] #{@profile['id']}"
      #   # 
      #   # 

      #   @state = params[:state]
      #   if Purchase.exists? @state.to_i
      #     @purchase = Purchase.find(@state.to_i)
      #     if @purchase.buyer_id
      #       Rails.logger.info("this purchase has a buyer_id of #{@purchase.buyer_id}")
      #       @user = User.find(@purchase.buyer_id)
      #       @user.facebook_id = @profile['id']
      #     end
      #   else
      #     @user = User.find_or_create_by_facebook_id @profile['id']
      #   end    
        
      #   # 
      #   #  made it through the if statement! ActiveRecord::RecordInvalid (Validation failed: Email has already been taken):
      #   @purchase.buyer_id = @user.id
      #   @purchase.save
      #   @product = Product.find @purchase.product_id
      #   @purchases = Purchase.where(:buyer_id => @user.id)
      user = User.find_or_create_by_facebook_id(@profile['id'])
      user.role = "member"
      user.save
      session[:user_id] = user.id
       end
    end


    # unless params[:code]
    #   redirect_to code
    # else
    #   code = @oauth.get_access_token(code)
    # end
    # Rails.logger.info @oauth.get_access_token(code)
    # @oauth.get_user_info_from_cookies(cookies)
    # Rails.logger.info @oauth.get_user_info_from_cookies(cookies)
    # Rails.logger.info @oauth
    # # user = User.from_omniauth(env["omniauth.auth"])
    # Rails.logger.info user.inspect
    #session[:user_id] = @user.id
    #session
    redirect_to root_url

  end

  def new
    super
    session[:user_id] = @user.id
  end

  def login
    setup_oauth(params[:donation_id])
    Rails.logger.info @url_for_facebook
    redirect_to @url_for_facebook
  end
end