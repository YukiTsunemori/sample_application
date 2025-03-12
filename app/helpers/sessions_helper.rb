# frozen_string_literal: true

module SessionsHelper
  # module SessionsHelper ... endを定義し、
  # すべてのコントローラーの親であるapplication_controllerでincludeすることにより、
  # すべてのコントローラーで以下のメソッドが使えるようになる。

  # 渡されたユーザでログインする
  def log_in(user)
    session[:user_id] = user.id
    # session情報はブラウザに保存される

    # セッションリプレイ攻撃から保護する
    session[:session_token] = user.session_token
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  # （controllerの中のrememeberとuser.rbのrememberメソッドは違う）
  # 今回の場合、引数にuserオブジェクトを渡す。
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーが存在していて、かつそのユーザーが現在ログインしているユーザーである場合 => True
  def current_user?(user)
    user && user == current_user
    # binding.irb
    # user => id:1, name:Tsunemori, email:yuki.tsunemori1229@gmail.com....
  end

  # ユーザがログインしていればTrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def store_location
    # ログイン前にアクセスしようとして入れなかったそのページのURLを保存する
    # ログインを終えるとアクセスしようとしたページにリダイレクトしてくれる。
    session[:forwarding_url] = request.original_url if request.get?
    # request.original_urlはユーザーが今いるページのウェブアドレス（URL）を取り出す命令
    # if request.get?は「そのページにGETリクエストが送られた場合だけ」という条件設定
  end
end
