class CommentsController < ApplicationController
  before_action :find_commentable
  before_action :set_post_and_comments, only: [:create, :destroy, :update]
  after_action :slack, only: [:create]

  def show
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new comment_params
    @comment.author = current_user if current_user

    if @comment.save
      respond_to do |format|
        format.html do
          redirect_to @commentable
        end
        format.js
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])

    if current_user == @comment.author
      @comment.public = false
      @comment.save
        respond_to do |format|
          format.html do
            redirect_to @commentable
          end
          format.js
        end
    else
      redirect_to root_path
    end
  end

  def destroy

    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html do
        redirect_to @commentable
      end
      format.js
    end
  end

  private

  def set_post_and_comments
    @post = @commentable
    @comments = @commentable.comments.where(public: true).order("created_at asc")
  end

  def comment_params
    params.require(:comment).permit(:body, :author_id, :post_id, :public)
  end

  def find_commentable
    @commentable = Comment.find(params[:comment_id]) if params[:comment_id]
    @commentable = Post.find_by_slug(params[:post_id]) if params[:post_id]
  end

  def comment_url
    post_url(@commentable, anchor: "comment-#{@comment.id}")
  end

  def slack
    Slacked.post_async "#{@comment.author.name} commented: #{@comment.body} - #{comment_url}", {channel: 'general', username: 'Comment Bot'}
  end
end
