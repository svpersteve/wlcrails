class CommentsController < ApplicationController
  before_action :find_commentable
  before_action :set_post_and_comments, only: [:create, :destroy, :update]

  def show
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new comment_params
    @comment.author = current_user if current_user
    notify_post_author(@commentable, current_user) unless @commentable.author == current_user
    notify_mentioned_users(@comment)

    if @comment.save
      respond_to do |format|
        format.html do
          redirect_to @commentable, anchor: "comment-#{@comment.id}"
        end
        format.js
      end
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

  def hide
    find_comment
    @post = @comment.commentable

    @comment.update(public: false)

    if @comment.save
      render :update
    end
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

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

  def notify_post_author(post, current_user)
    Notification.create(user: post.author, notified_by: current_user, notifiable: post, action: 'commented on your')
  end

  def notify_mentioned_users(comment)
    mention = ProcessMention.new
    mention.add_after_callback Proc.new { |comment, user| Notification.create(user: user, notified_by: comment.author, notifiable: comment, action: 'mentioned you') }
    mention.process_mentions(comment)
  end
end
