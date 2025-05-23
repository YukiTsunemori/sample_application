# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end
  # ーーーーーーーー@userが有効であるべきーーーーーーー
  test 'should be valid' do
    assert @user.valid?
  end
  # ーーーーーーー@user.nameが空白であるべきではない検証ーーーーーーー
  test 'name should be present' do
    @user.name = '      '
    assert_not @user.valid?
  end
  # ーーーーーーー@user.emailが空白であるべきではない検証ーーーーーーー
  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end
  # ーーーーーーー@user.nameが51文字であるべきではない検証ーーーーーーー
  # user.rbのvalidatesメソッドでMAX50文字で定義しているから、assert_notでfalseが返るべき。
  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end
  # ーーーーーーー@user.emailが244文字以上であるべきではない検証ーーーーーーー
  # user.rbのvalidatesメソッドでMAX255文字文字で定義しているから、assert_notでfalseが返るべき。
  test 'email should not be too long' do
    @user.email = "#{'a' * 244}@example.com" # 　=> 256文字になる => assert_notでfalseが返るべき
    assert_not @user.valid?
  end
  # ーーーーーーーemailが有効なアドレスであるべきかーーーーーーー
  # 有効なフォーマットであるいくつかのアドレスを用意し変数へ代入
  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn yuki.tsunemori@example.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # 無効なメールアドレスであればfalseが返る検証。
  # 無効なフォーマットであるいくつかのアドレスを用意し変数へ代入
  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} このアドレスは有効ではございません"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    # ユーザーは自分自身をフォローできない
    michael.follow(michael)
    assert_not michael.following?(michael)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # フォロワーがいるユーザー自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
