require 'rails_helper'

describe 'users/_results.html.haml' do
  let(:user) { FactoryGirl.create(:user, name: 'Jake Shears') }
  let(:users) { [user] }

  let(:language) { FactoryGirl.create(:language, id: 26) }
  let(:languages) { [language] }

  let(:current_user) { double { :user } }

  before do
    allow(user).to receive(:primary_languages).and_return(languages)

    assign(:users, users)
    assign(:languages, languages)
  end

  it 'displays a link to each user' do
    render
    expect(rendered).to have_link('Jake Shears', href: user_path(user))
  end

  it 'displays social links for each user' do
    render
    expect(rendered).to render_template(partial: 'users/_social_links', locals: { user: user })
  end

  it 'displays a link to each user\'slanguage' do
    render
    expect(rendered).to have_link('Ruby', href: language_path(language))
  end
end
