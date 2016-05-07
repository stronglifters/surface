class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, type: :uuid, index: true, null: false
      t.string :ip
      t.text :user_agent
      t.datetime :accessed_at
      t.datetime :revoked_at

      t.timestamps null: false
    end
  end
end
