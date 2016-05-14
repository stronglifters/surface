class CreateReceivedEmails < ActiveRecord::Migration
  def change
    create_table :received_emails, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, index: true, type: :uuid
      t.text :to
      t.text :from
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
