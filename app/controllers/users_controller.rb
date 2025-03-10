# frozen_string_literal: true

class UsersController < ApplicationController 
  # edit, updateアクションを呼び出す寸前で、logged_in_userメソッドを呼び出す。
  # :onlyオブションで指定したアクションだけで適用される。今回の場合は、editとupdate
  before_action :logged_in_user,  only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]


  def show
    @user = User.find(params[:id])
    # debugger
    # binding.irb
  end

  def new 
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
    # @user変数に代入しなくても、beforeメソッドで本人かどうかのチェックを終えているので、
    # ここでは再代入しない。
    # @user = User.find(params[:id])
  end

  def update
    # privateメソッドないで定義したuser_paramsの戻り値をここでも利用する。
    # => マスアサインメントの脆弱性を防止する。
    if @user.update(user_params)
      flash[:success] = "Updated Profile"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end

    # @user変数に代入しなくても、beforeメソッドで本人かどうかのチェックを終えているので、
    # ここでは再代入しない。
    # @user = User.find(params[:id])
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
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
end