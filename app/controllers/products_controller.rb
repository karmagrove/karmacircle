class ProductsController < ApplicationController

   before_action :set_product, only: [:show, :edit, :update, :destroy]

   before_action :verify_owner, only: [:edit, :update, :destroy] 

   before_action :set_user_products, only: [:index]
   #before_action :admin_only, :only => [:index]
  # GET /products
  # GET /products.json
  def index
    Rails.logger.info("@products.inspect")
    Rails.logger.info(@products.inspect)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new

    @product = Product.new
    @product_url = "/users/#{current_user.id}/products"
    Rails.logger.info("@product.inspect")
    Rails.logger.info(@product.inspect)
  end

  # GET /products/1/edit
  def edit
    #@product = Product.find(params[:id])
    @product_url = "/users/#{current_user.id}/products/#{params[:id]}"
    Rails.logger.info("product_url #{@product_url}")
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user_id = params[:user_id]

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    #@product = Product.find(params[:id])
    Rails.logger.info("WHAT THE FUCK? product_params: #{product_params.inspect} product: #{@product}")
    respond_to do |format|
      if @product.update_attributes(product_params)
        format.html { redirect_to "/users/#{current_user.id}/products", notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to "/users/#{current_user.id}/products", notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_user_products
      @products = Product.where(:user_id => params[:user_id])
    end

    def admin_only
      unless current_user.admin?
        redirect_to :back, :alert => "Access denied."
      end
    end
  

    def product_url(product)
      return "/users/#{@product.user_id}/products/#{@product.id}"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def verify_owner
       unless current_user.id = params[:user_id]
        redirect_to "/", :alert => "Access denied. You must be the owner of the product to edit, delete, or create"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:description, :name, :price, :public, :donation_percent, :image_url, :user_id)
    end
end
