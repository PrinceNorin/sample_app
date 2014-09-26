require 'spec_helper'

describe "User Pages" do
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
      before do
        fill_in 'Name', with: 'norin'
        fill_in 'Email', with: 'norin.hor@gmail.com'
        fill_in 'Password', with: 'secret'
        fill_in 'Password Confirmation', with: 'secret'
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count)
      end
      
      describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email 'norin.hor@gmail.com' }
          
          it { should have_link 'Sign out' }
          it { should have_title user.name }
          it { should have_selector 'div.alert.alert-success', text: 'Welcome' }
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
