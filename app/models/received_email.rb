class ReceivedEmail < ApplicationRecord
  belongs_to :user
  serialize :to, JSON
  serialize :from, JSON
end
