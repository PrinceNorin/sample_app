require 'spec_helper'

describe "PasswordResets" do
  subject { page }
  
  describe "edit page" do
    let(:user) { FactoryGirl.create :user }
    before do
      visit new_password_users_path
      fill_in 'Email', with: user.email
      click_button 'Send Email'
      
      visit edit_password_reset_path(user.reload.password_reset_token,
                                     email: user.reload.email)
      fill_in 'New Password', with: 'new_password'
      click_button 'Reset Password'
    end
    
    it { should have_title full_title '' }
    it { should have_selector 'div.alert.alert-success' }
    specify { expect(user.reload.authenticate 'new_password').to eq user }
    specify { expect(user.reload.authenticate 'new_password').not_to eq false }
  end
end
