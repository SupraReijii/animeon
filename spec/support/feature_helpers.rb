module FeatureHelpers
  def sign_in user
    visit new_user_session_path

    fill_in 'user[username]', with: user.username
    fill_in 'user[password]', with: user.password

    find('form').submit
  end
end
