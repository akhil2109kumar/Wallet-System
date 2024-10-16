class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :team
  enum role: { member: 0, admin: 1, owner: 2 }
end
