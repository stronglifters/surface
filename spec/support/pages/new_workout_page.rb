require_relative "../page_model.rb"

class NewWorkoutPage < PageModel
  def initialize
    super new_workout_path
  end

  def change_body_weight(weight)
    within "#new_workout" do
      fill_in 'workout_body_weight', with: weight
    end
  end

  def click_start
    click_button 'Start'
  end
end
