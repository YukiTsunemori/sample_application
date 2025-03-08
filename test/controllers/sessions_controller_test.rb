# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'login with invalid information' do
    # ログインURLへ行く
    get login_path
    # sessionsコントローラのnewテンプレートが描画される
    assert_template 'sessions/new'
    # からのアドレス・パスワードが入る
    post login_path, params: { session: { email: '', password: '' } }
    # 失敗する
    assert_response :unprocessable_entity
    # 再度ログイン画面が描画される
    assert_template 'sessions/new'
    # フラッシュが空ではないですよね？
    assert_not flash.empty?
    # 一旦ホームに戻る => メッセージがエラーでまだ表示されることを確認する
    get root_path
    # フラッシュがまだ残っていますよね => エラーで残っていることを確認する
    assert flash.empty?
  end
end
