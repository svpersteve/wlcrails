class MeetupsController < ApplicationController
  before_action :get_meetup, only: [:show, :rsvp]
  before_action :find_comments, only: :show
  skip_before_action :verify_authenticity_token, only: [:search]

  def show
  end

  def index
    @search = Meetup.upcoming.ransack(params[:q])
    @search.sorts = 'date asc' if @search.sorts.empty?
    @meetups = @search.result
  end

  def search
    index
    render :index
  end

  def past_meetups
    @past_meetups = Meetup.past.all.order('date desc')
  end

  def rsvp # rubocop:disable Metrics/MethodLength
    rsvp = MeetupRsvp.find_by(meetup: @meetup, user: current_user)

    if rsvp.present?
      rsvp.destroy
      UserMailer.unrsvp_confirmation(current_user, @meetup).deliver_now
      flash[:alert] = "Thanks for updating your RSVP."
    else
      MeetupRsvp.create(meetup: @meetup, user: current_user)
      UserMailer.rsvp_confirmation(current_user, @meetup).deliver_now
      flash[:alert] = "You're coming to this meetup!"
    end
    redirect_to @meetup
  end

  private

  def get_meetup
    @meetup = Meetup.friendly.find(params[:id])
  end

  def find_comments
    @comments = @meetup.comments.published.most_recent_first
    @new_comment = @meetup.comments.new
    @new_reply = CommentReply.new
  end
end
