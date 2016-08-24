require 'rails_helper'

feature "User can sign in and out" do

  context "user not signed in and on the homepage" do
    it "should see a 'sign in ' link and a 'sign up' link" do
      visit('/')
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Sign up')
    end

    it "should not see a 'sign out' link" do
      visit('/')
      expect(page).not_to have_link('Sign out')
    end
  end

  context "user is signed in" do
    before do
      visit('/')
      click_link('Sign up')
      fill_in 'Email', with: 'Giancarlo@here.com'
      fill_in 'Password', with: 'Secret1234'
      fill_in 'Password confirmation', with: 'Secret1234'
      click_button 'Sign up'
    end

    it "'should see a sign out link'" do
      expect(page).to have_link('Sign out')
      # expect(page).to have_link('Edit account')
    end

    it "should not see a'sign up' and 'sign in' link " do
      expect(page).not_to have_link('Sign up')
      expect(page).not_to have_link('Sign in')
    end
  end

end
