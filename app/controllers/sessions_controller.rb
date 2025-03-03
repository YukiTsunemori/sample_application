class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # (nilガード）
      # find_byメソッドはオブジェクトが見つからなかった時、nilを返す（例外発生）
      # user.authenticateはnilを受け取らないので、エラーになる。そのため、アンパサンド*2で
      # true && trueの式を代わりに書いてあげる。
      reset_session
      log_in user
      redirect_to user_url(user)
      # ユーザが存在し且つパスが一致した場合=> Trueが帰った時
    else
    # alert-danger => 赤色のフラッシュ
    flash.now[:danger] = "Iinvalid email/password combination"
    # flash変数
    render 'new', status: :unprocessable_entity
    end
  end
  # => 入力されたメールとパスワードはハッシュとして、
  # {session{ "password"=> "foobar"}}のようにネスト構造になっている。
  # そのため、取り出す際はparams[:session][:email]でパラメータから取得できる。

  def destroy 
    log_out # helperで定義したログアウトメソッドの呼び出し
    redirect_to root_url, status: :see_other
  end
end
