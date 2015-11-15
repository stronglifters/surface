class ChangeDefaultSocialTolerance < ActiveRecord::Migration
  def change
    change_column_default(:profiles, :social_tolerance, nil)
  end
end
