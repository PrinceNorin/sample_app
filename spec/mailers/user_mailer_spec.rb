require "spec_helper"

describe UserMailer do
  describe "account_activation" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      mail.subject.should eq("Account activation")
      mail.to.should eq([user.email])
      mail.from.should eq(["noreply@obscure-depths-5917.herokuapp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi #{user.name}")
      mail.body.encoded.should match(user.activation_token)
      mail.body.encoded.should have_content(edit_account_activation_url user.activation_token, email: user.email)
    end
  end
  
  describe "password reset" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }
    
    before do
      user.update_attribute(:password_reset_token, User.new_remember_token)
    end

    it "renders the headers" do
      mail.subject.should eq("Account activation")
      mail.to.should eq([user.email])
      mail.from.should eq(["noreply@obscure-depths-5917.herokuapp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi #{user.name}")
      mail.body.encoded.should match(user.activation_token)
      mail.body.encoded.should have_content(edit_account_activation_url user.activation_token, email: user.email)
    end
  end
end
