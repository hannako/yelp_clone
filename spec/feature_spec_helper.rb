def sign_in(email,password)
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

def leave_review(thoughts,rating)
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end

def create_restaurant(restaurant_name,description)
  click_link 'Add a restaurant'
  fill_in 'Name', with: restaurant_name
  fill_in 'Description', with: description
  click_button 'Create Restaurant'
end
