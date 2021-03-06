require 'spec_helper'

describe "Authentication Pages" do
  subject { page }
  
  describe "signin page" do
    describe "when user hasn't signed in yet" do
      before { visit signin_path }
      
      it { should have_content 'Sign in' }
      it { should have_title full_title 'Sign in' }
      it { should have_link 'Reset Password', href: new_password_users_path }
      
      describe "follow reset password link" do
        before { click_link 'Reset Password' }
        it { should have_content 'Reset Password' }
        it { should have_title full_title 'Reset Password' }
      end
    end
  end
  
  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button 'Sign in' }
      
      it { should have_title 'Sign in' }
      it { should have_selector 'div.alert.alert-error' }
      
      describe "after visiting another page" do
        before { click_link 'Home' }
        
        it { should_not have_selector 'div.alert.alert-error' }
      end
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create :user }
      
      describe "when account is activated" do
        before do
          visit edit_account_activation_url(user.activation_token, email: user.email)
          sign_in user
        end
        
        it { should have_title user.name }
        it { should have_link 'Users', href: users_path }
        it { should have_link 'Profile', href: user_path(user) }
        it { should have_link 'Settings', href: edit_user_path(user) }
        it { should have_link 'Sign out', href: signout_path }
        it { should_not have_link 'Sign in', href: signin_path }
        
        describe "followed by signout" do
          before { click_link 'Sign out' }
          
          it { should have_link 'Sign in' }
        end
      end
      
      describe "when account is not activated" do
        before do
          user.update_attribute(:activated, false)
          sign_in user
        end
        
        it { should have_title full_title '' }
        it { should have_selector 'div.alert.alert-info' }
      end
    end
    
    describe "authorization" do
      describe "for signed-in users" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }
        
        describe "in the Users controller" do
          describe "visiting the new password page" do
            before { visit new_password_users_path }
            it { should have_title full_title 'Edit user' }
          end
        end
      end
      
      describe "for no-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }
        
        describe "in the Users controller" do
          describe "visiting the edit page" do
            before { visit edit_user_path user }
            
            it { should have_title 'Sign in' }
          end
          
          describe "submitting to the update action" do
            before { patch user_path(user) }
            specify { expect(response).to redirect_to(signin_path) }
          end
          
          describe "when attempting to visit a protected page" do
            before do
              visit edit_user_path(user)
              fill_in 'Email', with: user.email
              fill_in 'Password', with: user.password
              click_button 'Sign in'
            end
            
            describe "after signing in" do
              it "should render desired result" do
                expect(page).to have_title('Edit user')
              end
            end
          end
          
          describe "visiting the user index" do
            before { visit users_path }
            
            it { should have_title('Sign in') }
          end
          
          describe "visiting the following page" do
            before { visit following_user_path(user) }
            it { should have_title('Sign in') }
          end

          describe "visiting the followers page" do
            before { visit followers_user_path(user) }
            it { should have_title('Sign in') }
          end
        end
        
        describe "in the Relationships controller" do
          describe "submitting to the create action" do
            before { post relationships_path }
            specify { expect(response).to redirect_to(signin_path) }
          end

          describe "submitting to the destroy action" do
            before { delete relationship_path(1) }
            specify { expect(response).to redirect_to(signin_path) }
          end
        end
        
        describe "in microposts controller" do
          describe "submitting to the microposts create action" do
            before { post microposts_path }
            
            specify { expect(response).to redirect_to signin_path }
          end
          
          describe "submitting to the microposts destroy action" do
            let(:m) { FactoryGirl.create(:micropost) }
            before { delete micropost_path(m) }
            
            specify { expect(response).to redirect_to signin_path }
          end
        end
      end
      
      describe "as wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }
        before { sign_in user, no_capybara: true }
        
        describe "submitting g GET request to the Users#edit action" do
          before { get edit_user_path wrong_user }
          specify { expect(response).to redirect_to(root_url) }
          specify { expect(response.body).not_to match(full_title 'Edit user') }
        end
        
        describe "submitting a PATCH request to the Users#update action" do
          before { patch user_path wrong_user }
          specify { expect(response).to redirect_to(root_url) }
        end
      end
      
      describe "as non-admin user" do
        let(:no_admin) { FactoryGirl.create(:user) }
        let(:user) { FactoryGirl.create(:user) }
        
        before { sign_in no_admin, no_capybara: true }
        
        describe "submitting a DELETE request to User destroy action" do
          before { delete user_path(user) }
          specify { expect(response).to redirect_to root_path }
        end
      end
    end
  end
end
