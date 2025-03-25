# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    # remember_meの値が１であればtrue, 0であればfalse
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        # (nilガード）
        # find_byメソッドはオブジェクトが見つからなかった時、nilを返す（例外発生）
        # user.authenticateはnilを受け取らないので、エラーになる。そのため、アンパサンド*2で
        # true && trueの式を代わりに書いてあげる。
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user #ApplicationControllerでincludeされたsessions_helperのlog_inメソッドを呼び出す。
        redirect_to forwarding_url || user
        # ユーザが存在し且つパスが一致した場合=> Trueが帰った時
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity # これを書かないとflashメッセージが表示されない
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
