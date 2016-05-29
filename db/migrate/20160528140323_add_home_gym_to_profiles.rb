class AddHomeGymToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :gym, index: true, foreign_key: true, type: :uuid
  end
end
