class Step < ActiveRecord::Base
  belongs_to :course
  has_many :comments, as: :commentable
  has_many :step_completions
  has_many :users, -> { distinct }, through: :step_completions

  extend FriendlyId
  friendly_id :position, use: [:slugged, :finders]

  def author
    course.author
  end

  def completed_by?(user)
    step_completions.where(user: user).present?
  end
end