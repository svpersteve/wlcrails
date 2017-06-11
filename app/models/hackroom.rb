class Hackroom < ActiveRecord::Base
  has_many :user_hackrooms
  has_many :users, through: :user_hackrooms
  has_many :hackroom_languages
  has_many :languages, through: :hackroom_languages
  has_many :hackroom_primaries
  has_many :primary_languages, through: :hackroom_primaries, source: :language
  has_many :hackroom_owners
  has_many :owners, through: :hackroom_owners, source: :user
  has_many :comments, as: :commentable
  belongs_to :author, class_name: 'User'

  validates :name, presence: true, uniqueness: true

  scope :in_popularity_order, -> { order('popularity_score desc') }

  extend FriendlyId
  friendly_id :name, use: :slugged

  def all_members
    (owners.all + users.all).uniq
  end

  def colour
    primary_languages&.first&.colour || '#000000'
  end

  def title
    name
  end
end
