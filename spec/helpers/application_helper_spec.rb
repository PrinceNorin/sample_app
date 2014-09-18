require 'spec_helper'

describe "ApplicationHelper" do
  describe "full_title" do
    it "should include the page title" do
      expect(full_title 'foo').to match(/foo/)
    end
    
    it "should include the base title" do
      expect(full_title 'foo').to match(/\ARuby on Rails Tutorial App/)
    end
    
    it "should not include the page title and verticle bar at home page" do
      expect(full_title '').to_not match(/[\|]/)
    end
  end
end