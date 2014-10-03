require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @micropost = user.microposts.build(content: 'Lorem ipsum')
  end
  
  subject { @micropost }
  
  it { should respond_to :content }
  it { should respond_to :user_id }
  # it { should respond_to :from_users_followed_by }
  it { should be_valid }
  its(:user) { should eq user }
  
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    
    it { should_not be_valid }
  end
  
  describe "when content is" do
    describe "blank" do
      before { @micropost.content = ' ' }
      
      it { should_not be_valid }
    end
    
    describe "nil" do
      before { @micropost.content = nil }
      
      it { should_not be_valid }
    end
    
    describe "too long" do
      before { @micropost.content = 'a' * 141 }
      
      it { should_not be_valid }
    end
  end
end
