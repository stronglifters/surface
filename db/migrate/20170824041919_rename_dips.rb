class RenameDips < ActiveRecord::Migration[5.0]
  def change
    Exercise.where(name: "Dips").update_all(name: "Weighted Dips")
  end
end
