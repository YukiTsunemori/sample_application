require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  # test "should get root" do
  #   get （コードを書き込む）
  #   assert_response （コードを書き込む）
  # end
  
  test "should get home" do
    # GET /static_pages/home
    get home_path
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
    # assertは何かが返ってくるべき=>successとなる。という定義文
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
  end


end
