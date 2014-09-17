require 'spec_helper'

describe "Static Pages" do
  let(:base_title) { 'Ruby on Rails Tutorial App' }
  
  describe "Home Pages" do
    it "should have the conRtent 'Sample App'" do
      visit root_path
      expect(page).to have_content('Sample App')
    end
    
    it "should have the right title" do
      visit root_path
      expect(page).to have_title("#{base_title}")
    end
    
    it "should not have the page title ' | Home'" do
      visit root_path
      expect(page).to_not have_title(' | Home')
    end
  end
  
  describe "Help Pages" do
    it "should have the content 'Help'" do
      visit help_path
      expect(page).to have_content('Help')
    end
    
    it "should have the right title" do
      visit help_path
      expect(page).to have_title("#{base_title} | Help")
    end
  end
  
  describe "About Pages" do
    it "should have the content 'About'" do
      visit about_path
      expect(page).to have_content('About Us')
    end
    
    it "should have the right title" do
      visit about_path
      expect(page).to have_title("#{base_title} | About")
    end
  end
  
  describe "Contact Pages" do
    it "should have the content 'Contact'" do
      visit contact_path
      expect(page).to have_content('Contact')
    end
    
    it "should have the right title" do
      visit contact_path
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end
