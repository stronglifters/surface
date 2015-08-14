class AddProfileForEachUser < ActiveRecord::Migration
  def up
    User.find_each do |user|
      Profile.create!(user: user, gender: nil, social_tolerance: nil) if user.profile.nil?
    end
  end
  
  def down
  end
end
