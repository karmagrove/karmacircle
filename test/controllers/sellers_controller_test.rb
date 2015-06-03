require 'test_helper'

class SellersControllerTest < ActionController::TestCase
  setup do
    @seller = sellers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sellers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seller" do
    assert_difference('Seller.count') do
      post :create, seller: { city: @seller.city, description: @seller.description, email: @seller.email, name: @seller.name, password: @seller.password, state: @seller.state, stripe_id: @seller.stripe_id, url: @seller.url }
    end

    assert_redirected_to seller_path(assigns(:seller))
  end

  test "should show seller" do
    get :show, id: @seller
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @seller
    assert_response :success
  end

  test "should update seller" do
    patch :update, id: @seller, seller: { city: @seller.city, description: @seller.description, email: @seller.email, name: @seller.name, password: @seller.password, state: @seller.state, stripe_id: @seller.stripe_id, url: @seller.url }
    assert_redirected_to seller_path(assigns(:seller))
  end

  test "should destroy seller" do
    assert_difference('Seller.count', -1) do
      delete :destroy, id: @seller
    end

    assert_redirected_to sellers_path
  end
end
