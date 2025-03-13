# アプリケーション全体で共通するデフォルトのfromアドレス

class ApplicationMailer < ActionMailer::Base
  default from: 'user@realdomain.com'
  layout 'mailer'
end
