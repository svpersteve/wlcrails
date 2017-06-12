class Comment < ActiveRecord::Base
  after_create :announce_comment

  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :replies, class_name: 'CommentReply'

  validates :body, presence: true

  scope :published, -> { where(public: true) }
  scope :most_recent_first, -> { order("created_at desc") }
  scope :in_created_by_order, -> { order('created_at asc') }
  scope :from_posts, -> { where(commentable_type: 'Post') }
  scope :last_three, -> { order('created_at desc').limit(3).reverse }

  def description
    "your comment"
  end

  private

  def announce_comment
    Slacked.post_async slack_message, channel: slack_channel, username: 'Comment Bot'
  end

  def slack_message
    comment_url = Rails.application.routes.url_helpers.post_path(commentable, anchor: "comment-#{id}")
    "#{author.name} commented: #{body} - #{link_host}#{comment_url}"
  end

  def comment_url
    if commentable_type == 'Post'
      post_url(commentable, anchor: "comment-#{id}")
    elsif commentable_type == 'Language'
      language_url(commentable, anchor: "comment-#{id}")
    elsif commentable_type == 'Hackroom'
      hackroom_url(commentable, anchor: "comment-#{id}")
    end
  end

  def slack_channel
    Rails.env.production? ? 'general' : 'testing'
  end

  def link_host
    "http://westlondoncoders.com"
  end
end
