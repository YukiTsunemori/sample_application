class User < ApplicationRecord 
  has_many :microposts, dependent: :destroy #ユーザーが削除された時、投稿も一緒に破棄されるべき
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # ユーザーは複数のポストをもつ => 一対多の構造
  # getterとsetterメソッドを使えるようにする
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,    presence: true, length: { maximum: 255 },
                       format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: true }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def User.digest(string)
    # fixtures/users.ymlでUser.digestメソッドを呼び出せるよう、ここで定義
    # 引数に渡された文字列をハッシュ化するメソッド。
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost) # rubocop:disable Style/HashSyntax
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
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end
  #  binding.irb

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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # アカウントを有効化する
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合は、trueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    # ユーザー1がフォローしているユーザーすべてをSELECTする=>サブセレクトはサブクエリの一種
    following_ids = "select followed_id
                     from relationships
                     where follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR
                     user_id = :user_id", user_id: id)
                    .includes(:user, image_attachment: :blob)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end


  private
    # メールアドレスを全て小文字にする
    # あとでコールバック関数として呼び出される
    def downcase_email
      self.email = email.downcase
    end

    # 有効かトークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    
end
