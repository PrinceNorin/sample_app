# Sign in failed steps
Given(/^users visit signin page$/) do
  visit signin_path
end

When(/^they submit invalid signin information$/) do
  click_button 'Sign in'
end

Then(/^they should see error message$/) do
  expect(page).to have_selector('div.alert.alert-error')
end

# Sign in successful steps
Given(/^users visit sigin page$/) do
  visit signin_path
end

Given(/^the user has an account$/) do
  @user = FactoryGirl.create(:user)
end

When(/^the user submit valid information$/) do
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign in'
end

Then(/^they should see their profile page$/) do
  expect(page).to have_link 'Profile', href: user_path(@user)
  expect(page).to have_title @user.name
end

Then(/^they should see signout link$/) do
  expect(page).to have_link 'Sign out', href: signout_path
end
