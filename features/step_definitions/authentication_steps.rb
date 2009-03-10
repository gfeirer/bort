Dado /^que tengo una cuenta activa con nombre de usuario "(.*)"$/ do |login|
  if User.find_by_login(login).nil?
    user = Factory(:user, :login => login, :password => login, :password_confirmation => login)
    user.register!
    user.activate!
  end
  User.count.should_not == 0
end

When /^me logeo como "(.*)"$/ do |login|
  fill_in("login", :with => login)
  fill_in("password", :with => login)
  click_button("Iniciar sesión")
end


Cuando /^me logeo como "(.*)" con contraseña errónea$/ do |login|
  fill_in("login", :with => login)
  fill_in("password", :with => "contraseñaerronea")
  click_button("Iniciar sesión")
end


