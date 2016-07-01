require_relative "../page_model.rb"

class EditWorkoutPage < PageModel
  def initialize(workout)
    super edit_workout_path(workout)
  end

  def open_section(exercise)
    click_link(exercise.name)
  end

  def complete(set:, repetitions: 5)
    click_map = { 5 => 1, 4 => 2, 3 => 3, 2 => 4, 1 => 5 }
    click_map[repetitions].times do
      find_by_id(set.id).click
      wait_for_ajax
    end
  end
end
