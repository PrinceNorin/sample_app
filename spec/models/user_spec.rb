require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build :user }
  subject { @user }
  
  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :password_digest }
  it { should respond_to :remember_token }
  it { should respond_to :authenticate }
  it { should respond_to :admin }
  it { should respond_to :microposts }
  it { should respond_to :feed }
  it { should be_valid }
  
  describe "when name is not present" do
    before { @user.name = '' }
    
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = '' }
    
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @user.name = 'a' * 51 }
    
    it { should_not be_valid }
  end
  
  describe "when email is not in correct format" do
    it "should be invalid" do
      address = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      address.each do |addr|
        @user.email = addr
        expect(@user).to_not be_valid
      end
    end
  end
  
  describe "when email is in correct format" do
    let(:address) { %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn] }
    
    it "should be valid" do
      address.each do |addr|
        @user.email = addr
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email is not unique" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
  
  describe "when email is mixcase" do
    let(:mix_case_email) { 'norin@example.com' }
    
    it "should save as all downcase" do
      @user.email = mix_case_email.upcase
      @user.save
      
      expect(@user.reload.email).to_not eq(mix_case_email.upcase)
      expect(@user.reload.email).to eq(mix_case_email.downcase)
    end
  end
  
  describe "when password is not present" do
    before do
      @user.password = ''
      @user.password_confirmation = ''
    end
    
    it { should_not be_valid }
  end
  
  describe "when password_confirmation is mismatch" do
    before { @user.password_confirmation = 'mismatch' }
    
    it { should_not be_valid }
  end
  
  describe "when password is too short" do
    before do
      @user.password = 'secre'
      @user.password_confirmation = 'secre'
    end
    
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by email: @user.email }
    
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_passowrd) { found_user.authenticate 'invalid' }
      it { should_not eq user_for_invalid_passowrd }
      specify { expect(user_for_invalid_passowrd).to be_false }
    end
  end
  
  describe "remember token" do
    before { @user.save }
    
    its(:remember_token) { should_not be_blank }
  end
  
  describe "with admin attributes set to true" do
    before do
      @user.save!
      @user.toggle! :admin
    end
    
    it { should be_admin }
  end
  
  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    
    it "should have the right microposts in the right order" do
      expect(@user.reload.microposts.to_a).to eq [newer_micropost, older_micropost]
    end
    
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |m|
        expect(Micropost.where id: m.id).to be_empty
      end
    end
    
    describe "status" do
      let(:unfollow_post) do
        FactoryGirl.create :micropost, user: FactoryGirl.create(:user)
      end
      
      its(:feed) { should include newer_micropost }
      its(:feed) { should include older_micropost }
      its(:feed) { should_not include unfollow_post }
    end
  end
end
