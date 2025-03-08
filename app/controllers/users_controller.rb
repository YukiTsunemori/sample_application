class UsersController < ApplicationController
  def new
  end

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
      flash[:success] = "Welcome to the Sample App!"
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

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
