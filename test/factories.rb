require 'factory_girl'

# This will guess the User class
Factory.define :user do |u|
  u.login 'user'
  u.password 'password'
  u.password_confirmation 'password'
  u.email 'test@example.com'
end

## This will use the User class (Admin would have been guessed)
#Factory.define :admin, :class => User do |u|
#  u.first_name 'Admin'
#  u.last_name  'User'
#  u.admin true
#end
