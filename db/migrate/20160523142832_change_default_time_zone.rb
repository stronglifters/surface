class ChangeDefaultTimeZone < ActiveRecord::Migration
  def up
    change_column :profiles, :time_zone, :string, default: "Etc/UTC", null: false
    Profile.where(time_zone: "UTC").update_all(time_zone: "Etc/UTC")
  end

  def down
    change_column :profiles, :time_zone, :string, default: "UTC", null: false
    Profile.where(time_zone: "Etc/UTC").update_all(time_zone: "UTC")
  end
end
