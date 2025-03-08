# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    # remember_meの値が１であればtrue, 0であればfalse
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # (nilガード）
      # find_byメソッドはオブジェクトが見つからなかった時、nilを返す（例外発生）
      # user.authenticateはnilを受け取らないので、エラーになる。そのため、アンパサンド*2で
      # true && trueの式を代わりに書いてあげる。
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      log_in user
      redirect_to user_url(user)
      # ユーザが存在し且つパスが一致した場合=> Trueが帰った時
    else
      # alert-danger => 赤色のフラッシュ
      flash.now[:danger] = 'Iinvalid email/password combination'
      # flash変数
      render 'new', status: :unprocessable_entity
    end
  end
  # => 入力されたメールとパスワードはハッシュとして、
  # {session{ "password"=> "foobar"}}のようにネスト構造になっている。
  # そのため、取り出す際はparams[:session][:email]でパラメータから取得できる。

  def destroy
    log_out if logged_in? # helperで定義したログアウトメソッドの呼び出し
    redirect_to root_url, status: :see_other
  end
end
