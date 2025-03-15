# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    # render ...
    # アクション直下にレンダリングさせるファイルを指定できる
    # renderなどの指示がない場合、app/views/static_pages/home.html.erbが返される=>デフォルト
  end

  def help; end

  def about
    @hello = 'This is about page mother fucker'
  end

  def contact; end
end
