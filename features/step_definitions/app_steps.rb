Given(/^I am logged in as "([^\"]*)" with the password "([^\"]*)"$/) do |user, password|
  visit login_path
  fill_in 'user_session[login]', :with => user
  fill_in 'user_session[password]', :with => password
  click_button 'Login'
end

Then /^debug$/ do
  save_and_open_page
end
