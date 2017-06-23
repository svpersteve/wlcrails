class UserMailer < ApplicationMailer
  include SendGrid
  default from: 'West London Coders <people@westlondoncoders.com>'

  def welcome_email(user)
    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"<%Unsubscribe%>","text/plain":"<% %>"}}}}'
    @user = user
    mail to: user.email, subject: "Welcome to West London Coders!"
  end

  def rsvp_confirmation(user, meetup)
    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"<%Unsubscribe%>","text/plain":"<% %>"}}}}'
    @user = user
    @meetup = meetup
    mail to: user.email, subject: "You're attending on #{@meetup.start_date}!"
  end

  def unrsvp_confirmation(user, meetup)
    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"<%Unsubscribe%>","text/plain":"<% %>"}}}}'
    @user = user
    @meetup = meetup
    mail to: user.email, subject: "You're no longer attending on #{@meetup.start_date}"
  end

  def organiser_promotion(user)
    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"<%Unsubscribe%>","text/plain":"<% %>"}}}}'
    @user = user
    mail to: @user.email, subject: "Thanks for your support!", from: 'Steve Brewer <steve@westlondoncoders.com>'
  end

  def meetup_scheduled(meetup, user)
    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"<%Unsubscribe%>","text/plain":"<% %>"}}}}'
    @user = user
    @meetup = meetup
    mail to: user.email, subject: "We've scheduled a meetup for #{@meetup.start_date}"
  end
end
