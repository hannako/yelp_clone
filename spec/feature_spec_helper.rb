def sign_in
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: 'test@test.co.uk'
  fill_in 'Password', with: '123456'
  click_button 'Log in'
end
