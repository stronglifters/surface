class ReceivedEmail < ActiveRecord::Base
  belongs_to :user
  serialize :to, JSON
  serialize :from, JSON
end
