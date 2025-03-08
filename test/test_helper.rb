ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # 指定のワーカー数でテストを並列実行する
  parallelize(workers: :number_of_processors)
  # test/fixtures/*ymlのfixtureを全てセットアップする
  fixtures :all
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
  # Add more helper methods to be used by all tests here...
end
