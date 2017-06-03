class UsersController < ApplicationController
  before_action :get_user, except: [:index, :search, :organisers]
  skip_before_action :verify_authenticity_token, only: [:search]

  def show
    @posts = Post.all.where(created_by_id: @user).order("created_at asc")
  end

  def index
    @search = User.listed.ransack(params[:q])
    @search.sorts = 'updated_at desc' if @search.sorts.empty?
    @users = @search.result.includes(:languages, :primary_languages)
  end

  def search
    index
    render :index
  end

  def languages
    respond_to do |format|
      format.js
    end
  end

  def hackrooms
    respond_to do |format|
      format.js
    end
  end

  def posts
    respond_to do |format|
      format.js
    end
  end

  def events
    respond_to do |format|
      format.js
    end
  end

  def organisers
    @organisers = User.organiser
  end

  def edit
    authorize! :edit, @user
    @languages = Language.all
  end

  def update
    authorize! :update, @user
    if @user.update(user_params)
      redirect_to user_path(user_params)
    else
      render :edit
    end
  end

  def follow
    @user_follow = UserFollow.find_or_create_by(follower_id: current_user.id, user_id: @user.id)
    @user.user_follows_count += 1
    render :follows
  end

  def unfollow
    @user_follow = UserFollow.find_by(follower_id: current_user, user_id: @user)
    @user_follow.destroy if @user_follow
    @user.user_follows_count -= 1
    render :follows
  end

  private

  def get_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params[:user].permit(:name, :listed, :bio, :image, :logo, :logo_link, :tagline, :twitter, :instagram, :github, :facebook, :linkedin, :permission, :website_url, :email, primary_language_ids: [], language_ids: [], interest_ids: [])
  end

  def require_admin_or_owner
    unless user_is_owner_or_admin
      redirect_to user_path(@user)
      flash[:alert] = "You're not authorised to do that"
    end
  end
end
