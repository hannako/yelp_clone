require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do
    before do
      User.create(email: "test@test.co.uk", password: "123456")
    end

    scenario 'if user logged in should display a prompt to add a restaurant' do
      sign_in("test@test.co.uk","123456")
      expect(page).to have_content 'No restaurants yet!'
      expect(page).to have_link 'Add a restaurant'
    end

  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
      User.create(email: "test@test.co.uk", password: "123456")
    end

    scenario 'if a user is logged in the restaurants are displayed' do
      sign_in("test@test.co.uk","123456")
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end

    scenario 'if a user is logged out the restaurants are displayed' do
      sign_in("test@test.co.uk","123456")
      click_link 'Sign out'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    before do
      User.create(email: "test@test.co.uk", password: "123456")
    end

    scenario 'prompts a signed in user to fill out a form, then display the new restaurant' do
      sign_in("test@test.co.uk","123456")
      create_restaurant('KFC','chicken')
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'a logged out user cannot add a new restaurant' do
      sign_in("test@test.co.uk","123456")
      click_link 'Sign out'
      expect(page).not_to have_content 'Add a restaurant'
    end
  end

  context 'an invalid restaurant' do

    before do
      User.create(email: "test@test.co.uk", password: "123456")
    end

    scenario 'a logged in user cannot submit a restaurant name that is too short' do
      sign_in("test@test.co.uk","123456")
      create_restaurant('kf',"chicken")
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'viewing restaurants' do

    before do
      User.create(email: "test@test.co.uk", password: "123456")
    end

    let!(:kfc) { Restaurant.create(name: 'KFC') }

    scenario 'lets a logged out user view a restaurant' do
      sign_in("test@test.co.uk","123456")
      click_link 'Sign out'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    before do
      Restaurant.create name: 'Pizza Express', description: 'Italian Stuff'
      User.create(email: "test@test.co.uk", password: "123456")
      User.create(email: "joe@bloggs.co.uk", password: "password123")
    end

    scenario 'lets the creator edit their restaurants' do
      sign_in("test@test.co.uk","123456")
      create_restaurant('KFC','Kentucky Fried Chicken')
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'a signed in user cannot edit a restaurant they did not create' do
      sign_in("test@test.co.uk","123456")
      create_restaurant('Whimpy','Burgers')
      click_link 'Sign out'
      click_link 'Sign in'
      fill_in 'Email', with: 'joe@bloggs.co.uk'
      fill_in 'Password', with: 'password123'
      click_button 'Log in'
      expect(page).not_to have_link 'Edit Whimpy'
      expect(page).not_to have_link 'Edit Pizza Express'
    end

    scenario 'a signed out user does not have option to edit restaurant' do
      sign_in("test@test.co.uk","123456")
      click_link 'Sign out'
      expect(page).not_to have_link 'Edit KFC'
    end

  end

  context 'deleting restaurants' do
    before do
      Restaurant.create name: 'McDonalds', description: 'Burgers'
      User.create(email: "test@test.co.uk", password: "123456")
    end

    scenario 'a signed in user can remove a restaurant they created, when they click delete link' do
      sign_in("test@test.co.uk","123456")
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      fill_in 'Description', with: 'Kentucky Fried Chicken'
      click_button 'Create Restaurant'
      expect(page).not_to have_link 'Delete McDonalds'
      expect(page).to have_link 'Delete KFC'
    end

    scenario 'the creator can delete a restaurant they own' do
      sign_in("test@test.co.uk","123456")
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      fill_in 'Description', with: 'Kentucky Fried Chicken'
      click_button 'Create Restaurant'
      click_link 'Delete KFC'
      expect(page).to have_content 'Restaurant deleted successfully'

    end

    scenario 'a logged out user does not have the option to delete a restaurant' do
      sign_in("test@test.co.uk","123456")
      click_link 'Sign out'
      expect(page).not_to have_link 'Delete KFC'
    end

  end
end
