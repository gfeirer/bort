When /^me logeo$/ do
  user = Factory(:user)
  user.register!
  user.activate!
  fill_in("username", :with => "user")
  fill_in("password", :with => "password")
  click_button("login")
end

When /^me logeo incorrectamente$/ do
  user = Factory(:user)
  user.register!
  user.activate!
  fill_in("username", :with => "user")
  fill_in("password", :with => "contraseñaerronea")
  click_button("login")
end


