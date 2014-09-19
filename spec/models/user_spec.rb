require 'spec_helper'

describe User do
  before { @user = User.new(name: 'norin', email: 'norin@example.com') }
  subject { @user }
  
  it { should respond_to :name }
  it { should respond_to :email }
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
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
end
