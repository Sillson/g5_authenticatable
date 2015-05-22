class Post < ActiveRecord::Base
  belongs_to :author, class: G5Authenticatable::User
end
