module FeatureHelpers
  def when_there_are_users
    @christina = FactoryBot.create(:user, name: 'Christina', email: 'dirrty@aguilera.com')
    @tom = FactoryBot.create(:user, name: 'Tom', email: 'tom@person.com')
  end

  def when_there_are_languages
    @ruby = FactoryBot.create(:language, name: 'Ruby')
    @python = FactoryBot.create(:language, name: 'Python')
  end

  def when_there_are_hackrooms
    @ruby_room = FactoryBot.create(:hackroom, name: 'Ruby room')
    @python_room = FactoryBot.create(:hackroom, name: 'Python room')
  end

  def when_there_are_posts
    @author = FactoryBot.create(:user, name: 'Author', email: 'dirrty@aguilera.com')
    @ruby_post = FactoryBot.create(:post, title: 'Ruby post', created_by: @author)
    @python_post = FactoryBot.create(:post, title: 'Python post', created_by: @author)
  end

  def then_i_should_be_redirected_to_people_page
    expect(current_path).to eq(users_path)
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
