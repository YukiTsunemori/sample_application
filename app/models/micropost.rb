class Micropost < ApplicationRecord
  belongs_to :user # 投稿は１つのユーザーしか持たない => 一対一の構造
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end # 投稿１件につき、１枚の画像という設計Userモデルとアップロードファイルを関連付けるメソッド


  default_scope -> { order(created_at: :desc) } 
  # SQLのorder by descにあたる
  # データベースから情報を取り出すときのルールを決めるためのもの
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
end
