class User < ApplicationRecord
  # getterとsetterメソッドを使えるようにする
  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :name,     presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,    presence: true, length: { maximum: 255},
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: true }
  
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  def User.digest(string)
    # fixtures/users.ymlでUser.digestメソッドを呼び出せるよう、ここで定義
    # 引数に渡された文字列をハッシュ化するメソッド。
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
    # 三項演算子 if else endを１行で書いている
  end

    # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続的セッションのためにユーザーをDBに記憶する
  def remember
    self.remember_token = User.new_token
    # ランダムなトークンをDBへupdate_attributeメソッドを使って保存する
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたremember_tokenがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    # 下の一行は次のコードと同等 => BCrypt::Password.new(remember_digest) == remember_token
    # is_password?で引数に渡されたものと一致すればtrueを返す論理値メソッドになる
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
