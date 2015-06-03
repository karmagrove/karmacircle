require 'test_helper'

class CharitiesControllerTest < ActionController::TestCase
  setup do
    @charity = charities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:charities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create charity" do
    assert_difference('Charity.count') do
      post :create, charity: { city: @charity.city, description: @charity.description, email: @charity.email, name: @charity.name, state: @charity.state, stripe_id: @charity.stripe_id, url: @charity.url }
    end

    assert_redirected_to charity_path(assigns(:charity))
  end

  test "should show charity" do
    get :show, id: @charity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @charity
    assert_response :success
  end

  test "should update charity" do
    patch :update, id: @charity, charity: { city: @charity.city, description: @charity.description, email: @charity.email, name: @charity.name, state: @charity.state, stripe_id: @charity.stripe_id, url: @charity.url }
    assert_redirected_to charity_path(assigns(:charity))
  end

  test "should destroy charity" do
    assert_difference('Charity.count', -1) do
      delete :destroy, id: @charity
    end

    assert_redirected_to charities_path
  end
end
