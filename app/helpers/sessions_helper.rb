module SessionsHelper
  # module SessionsHelper ... endを定義し、
  # すべてのコントローラーの親であるapplication_controllerでincludeすることにより、
  # すべてのコントローラーで以下のメソッドが使えるようになる。



  #渡されたユーザでログインする
  def log_in(user)
    session[:user_id] = user.id
    # session情報はブラウザに保存される
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
    if (user_id = session[:user_id]) #(ユーザーIDにユーザーIDのセッションを代入した結果)ユーザーIDのセッションが存在すれば
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 現在ログイン中のユーザを返す（いる場合）
  # def current_user
  #   if session[:user_id] # session情報はTRUEであれば　=>この構文はメモ化
  #       @current_user ||= User.find_by(id: session[:user_id]) # @current_userへ情報を代入する
  #   end
    # DBへの問い合わせをなるべく少なく実行したい。
  # end

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

  #現在のユーザをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
