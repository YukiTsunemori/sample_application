class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in user
      redirect_to user_url(user)
      # ユーザが存在し且つパスが一致した場合=> Trueが帰った時
    else
    flash.now[:danger] = "Iinvalid email/password combination"
    render 'new', status: :unprocessable_entity
    end
  end
  # => 入力されたメールとパスワードはハッシュとして、
  # {session{ password=> 'foobar'}}のようにネスト構造になっている。
  # そのため、取り出す際はparams[:session][:email]でパラメータから取得できる。

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
