module UserHelper
  def social_url(handle, site)
    link_to "https://#{site}.com/#{handle}", target: '_blank' do
      content_tag(:i, nil, class: ["fa", "fa-#{site}"])
    end
  end

  def hackroom_count(user)
    hackrooms = user.own_hackrooms.size + user.hackrooms.size
    pluralize(hackrooms, 'hackroom')
  end

  def interest_count(user)
    pluralize(user.interests.size, 'interest')
  end

  def language_count(user)
    languages = user.primary_languages.size + user.languages.size
    pluralize(languages, 'language')
  end

  def post_count(user)
    pluralize(user.posts.size, 'post')
  end

  def meetup_count(user)
    pluralize(user.events.size, 'meetup')
  end

  def list_all_sentence(users)
    users.map { |u| link_to(u.name, user_path(u)) }.to_sentence
  end

  def user_follower_count(user)
    case user.followers.count
    when 0
      nil
    when 1..3
      "followed by #{list_all_sentence(user.followers)}".html_safe
    else
      "followed by #{list_all(user.followers.take(3))} and #{remaining_like_count(user)}".html_safe
    end
  end

  def user_following?(current_user, user)
    current_user.followed_users.any? { |l| l == user }
  end
end
