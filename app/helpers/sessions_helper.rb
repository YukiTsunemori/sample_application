module SessionsHelper
  #渡されたユーザでログインする
  def log_in(user)
    session[:user_id] = user.id
    # session情報はブラウザに保存される
  end

  # 現在ログイン中のユーザを返す（いる場合）
  def current_user
    if session[:user_id] # session情報はTRUEであれば　=>この構文はメモ化
        @current_user ||= User.find_by(id: session[:user_id]) # @current_userへ情報を代入する
    end
    # DBへの問い合わせをなるべく少なく実行したい。
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
