require 'factory_girl'

# This will guess the User class
Factory.define :user do |u|
  u.login 'user'
  u.password {|a| "#{a.login}" }
  u.password_confirmation {|a| "#{a.login}" }
  u.email {|a| "#{a.login}@example.com".downcase }
end

## This will use the User class (Admin would have been guessed)
#Factory.define :admin, :class => User do |u|
#  u.first_name 'Admin'
#  u.last_name  'User'
#  u.admin true
#end
