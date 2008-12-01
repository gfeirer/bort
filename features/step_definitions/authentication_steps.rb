When /^me logeo$/ do
  user = Factory(:user)
  user.register!
  user.activate!
  fills_in("username", :with => "user")
  fills_in("password", :with => "password")
  clicks_button("login")
end

When /^me logeo incorrectamente$/ do
  user = Factory(:user)
  user.register!
  user.activate!
  fills_in("username", :with => "user")
  fills_in("password", :with => "contraseñaerronea")
  clicks_button("login")
end


