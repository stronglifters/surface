class AddDurationToRecommendations < ActiveRecord::Migration[5.0]
  def change
    add_column :recommendations, :duration, :integer
  end
end
