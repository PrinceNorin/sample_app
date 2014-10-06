require 'spec_helper'

describe "Accout Activations" do
  describe "edit" do
    let(:user) { FactoryGirl.create :user }
    before { visit "#{edit_account_activation_url user.activation_token}?email=#{user.email}" }
    
    specify { expect(user.activated?).to eq(true) }
  end
end
