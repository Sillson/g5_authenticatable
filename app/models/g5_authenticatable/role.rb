module G5Authenticatable
  class Role < ActiveRecord::Base
    has_and_belongs_to_many :users, :join_table => :g5_authenticatable_users_roles
    belongs_to :resource, :polymorphic => true

    scopify
  end
end
