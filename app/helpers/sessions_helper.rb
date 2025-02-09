module SessionsHelper
  #渡されたユーザでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザを返す（いる場合）
  def current_user
    if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
    end
    # なぜ、ログイン情報をif文で分岐しチェックしているのか。
    # →毎回find_byメソッドを読み込みするとデーターベースへの読み込み回数が増え負荷がかかる。
    # if文でtrueを返すことで読み込み回数を少なくする。
  end

  # ユーザがログインしていればTrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  #現在のユーザをログアウトする
  def log_out
    reset_session
    @current_user = nil
  end
end
