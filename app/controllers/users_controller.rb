# frozen_string_literal: true

class UsersController < ApplicationController # rubocop:disable Style/Documentation
  before_action :logged_in_user, only: [:edit, :update]

  def new; end

  def show
    @user = User.find(params[:id])
    # debugger
    # binding.irb
  end

  def new # rubocop:disable Lint/DuplicateMethods
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user # ユーザー登録に成功したら、そのままログインさせる
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destory
    # sessions_helperで定義している、log_outメソッドを呼び出す
    log_out
    redirect_to root_url, status: :see_other
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # privateメソッドないで定義したuser_paramsの戻り値をここでも利用する。
    # => マスアサインメントの脆弱性を防止する。
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end

    # beforeフィルタ

    # 　ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url, status: :see_other
      end
    end




end