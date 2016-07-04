class FixGenderDefaults < ActiveRecord::Migration[5.0]
  def up
    change_column_default :profiles, :gender, 0
  end

  def down
    change_column_default :profiles, :gender, nil
  end
end
