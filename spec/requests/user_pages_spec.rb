require 'spec_helper'

describe "UserPages" do
  subject { page }
  
  describe "Signup Page" do
    before { visit signup_path }
    
    it { should have_content('Sign up') }
    it { should have_title(full_title 'Sign up') }
  end
  
  describe "signup" do
    before { visit signup_path }
    let(:submit) { 'Create Account' }
    
    describe "with invalid data" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    
    describe "with valid data" do
      it "should create a user" do
        fill_in 'Name', with: 'norin'
        fill_in 'Email', with: 'norin.hor@gmail.com'
        fill_in 'Password', with: 'secret'
        fill_in 'Password Confirmation', with: 'secret'
        expect { click_button submit }.to change(User, :count)
      end
    end
  end
  
  describe "Profile page" do
    let(:user) { FactoryGirl.create :user }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end
