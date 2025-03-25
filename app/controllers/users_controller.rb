# frozen_string_literal: true

class UsersController < ApplicationController 
  # 指定したアクションを呼び出す寸前で、logged_in_userメソッドを呼び出す。
  # :onlyオブションで指定したアクションだけで適用される。
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # debugger
    # binding.irb
  end

  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  def edit
    # @user変数に代入しなくても、beforeメソッドで本人かどうかのチェックを終えているので、
    # ここでは再代入しない。
    # @user = User.find(params[:id])
  end

  # POST(PATCH) /editのform_withからparamsで取得した値をアップデート
  def update
    # privateメソッドないで定義したuser_paramsの戻り値をここでも利用する。
    # => マスアサインメントの脆弱性を防止する。
    # binding.irb
    if @user.update(user_params)
      flash[:success] = "Updated Profile"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
    # @user変数に代入しなくても、beforeメソッドで本人かどうかのチェックを終えているので、
    # ここでは再代入しない。
    # @user = User.find(params[:id])
    
  end

  def index
    # params[:page]はwill_paginateによって自動で生成される
    @users = User.paginate(page: params[:page])
    # irb :001> params[:page]
    # => "2"  クリックしたページ番号がparams引数として渡される
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    # binding.irb
    end
    

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
      # このメソッド全体では、「もし今のユーザーと違うユーザーのページを見ようとしたら、ホームに戻す」
      # unless @user == current_user => unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end