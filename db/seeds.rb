# サンプルユーザーを生成するRubyスクリプト（Railsタスクとも呼びます）を追加してみましょう。
# Railsではdb/seeds.rbというファイルを標準として使います。

# メインのサンプルユーザーを1人作成する
User.create!(name:  "Yuki Tsunemori",
             email: "yuki.tsunemori1229@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
            # create!としているのは、ユーザーが無効な場合にfalseを返すのではなく、例外を
            # 発生させることができる。そうすることで、見過ごしやすいエラーを回避できる。
end
