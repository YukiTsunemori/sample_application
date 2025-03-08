class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name,     presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,    presence: true, length: { maximum: 255},
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: true }
  
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  def User.digest(string)
<<<<<<< HEAD
    # fixtures/users.ymlでUser.digestメソッドを呼び出せるよう、ここで定義
    # 引数に渡された文字列をハッシュ化するメソッド。
=======
    # users.ymlで呼び出されたこのメソッドは渡された引数をハッシュ化してくれるメソッド
>>>>>>> refs/remotes/origin/main
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
    # 三項演算子 if else endを１行で書いている
  end
end
