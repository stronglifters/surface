class WarmUp
  DEADLIFT_INCREMENT_THRESHOLD_LB=220.0
  attr_reader :exercise, :sets

  def initialize(exercise)
    @sets = []
    @exercise = exercise
  end

  def add_set(weight, repetitions)
    @sets << ExerciseSet.new(
      type: :warm_up,
      exercise: exercise,
      target_weight: weight,
      target_repetitions: repetitions,
    )
    self
  end

  def self.calculate_for(exercise, target_weight)
    if exercise.name == "Deadlift"
      return dead_lift_warmup(exercise, target_weight)
    end

    if exercise.name == "Barbell Row"
      return barbell_row_warmup(exercise, target_weight)
    end

    return default_warmup(exercise, target_weight)
  end

  def self.dead_lift_warmup(exercise, target_weight)
    warmup = WarmUp.new(exercise)
    if (target_weight < 155.0)
      return warmup
    end
    if (target_weight < 175.0)
      return warmup.add_set(135.0, 5)
    end
    warmup.add_set(135.0, 5)
    if (target_weight < 200.0)
      return warmup.add_set(165.0, 5)
    end
    if (target_weight < DEADLIFT_INCREMENT_THRESHOLD_LB)
      return warmup.add_set(175.0, 5)
    end
    if (target_weight < 225.0)
      return warmup.add_set(185.0, 5)
    end
    warmup.add_set(185.0, 5)
    if (target_weight < 240.0)
      return warmup.add_set(205.0, 5)
    end
    if (target_weight < 250.0)
      return warmup.add_set(215.0, 5)
    end
    if (target_weight < 270.0)
      return warmup.add_set(225.0, 5)
    end
    warmup.add_set(225.0, 5)
    if (target_weight < 275.0)
      return warmup.add_set(245.0, 5)
    end
    if (target_weight < 290.0)
      return warmup.add_set(255.0, 5)
    end
    if (target_weight < 301.0)
      return warmup.add_set(265.0, 5)
    end
    warmup.add_set(265.0, 3)
    if (target_weight < 320.0)
      return warmup.add_set(285.0, 1)
    end
    if (target_weight < 330.0)
      return warmup.add_set(295.0, 1)
    end
    if (target_weight < 340.0)
      return warmup.add_set(305.0, 1)
    end
    if (target_weight < 350.0)
      return warmup.add_set(315.0, 1)
    end
    warmup.add_set(315.0, 3)
    if (target_weight < 360.0)
      return warmup.add_set(335.0, 1)
    end
    if (target_weight < 370.0)
      return warmup.add_set(340.0, 1)
    end
    if (target_weight < 380.0)
      return warmup.add_set(345.0, 1)
    end
    if (target_weight < 390.0)
      return warmup.add_set(350.0, 1)
    end
    if (target_weight < 395.0)
      return warmup.add_set(355.0, 1)
    end
    if (target_weight < 400.0)
      return warmup.add_set(360.0, 1)
    end
    return warmup.add_set(365.0, 1)
  end

  def self.barbell_row_warmup(exercise, target_weight)
    warmup = WarmUp.new(exercise)
    i = 3
    barbellRow = exercise.name == "Barbell Row" ? 1 : 0
    if ((barbellRow != 0 && target_weight < 105.0) || target_weight < 65.0)
      return warmup
    end
    if (barbellRow != 0 && target_weight < 145.0)
      return warmup.add_set(95.0, 5)
    end
    if (barbellRow == 0)
      warmup.add_set(45.0, 5)
      warmup.add_set(45.0, 5)
      if (target_weight < 95.0)
        return warmup
      end
    end
    if (barbellRow != 0 && target_weight < 160.0)
      return warmup.add_set(115.0, 5)
    end
    if (target_weight < 105.0)
      return warmup.add_set(65.0, 3)
    end
    if (target_weight < 125.0)
      return warmup.add_set(75.0, 3)
    end
    if (target_weight < 135.0)
      return warmup.add_set(85.0, 3)
    end
    if (barbellRow == 0)
      warmup.add_set(95.0, 5)
      if (target_weight < 150.0)
        return warmup.add_set(115.0, 3)
      end
      if (target_weight < 160.0)
        return warmup.add_set(125.0, 3)
      end
      if (target_weight < 185.0)
        return warmup.add_set(135.0, 3)
      end
    end
    if (target_weight < 185.0)
      return warmup.add_set(135.0, 3)
    end
    warmup.add_set(135.0, 5)
    if (target_weight < 200.0)
      return warmup.add_set(165.0, 3)
    end
    if (target_weight < DEADLIFT_INCREMENT_THRESHOLD_LB)
      return warmup.add_set(175.0, 3)
    end
    if (target_weight < 225.0)
      return warmup.add_set(185.0, 3)
    end
    if (barbellRow != 0)
      warmup.add_set(185.0, 5)
    else
      warmup.add_set(185.0, target_weight < 305.0 ? 3 : 5)
    end
    if (target_weight < 240.0)
      return warmup.add_set(205.0, 2)
    end
    if (target_weight < 250.0)
      return warmup.add_set(215.0, 2)
    end
    if (target_weight < 270.0)
      return warmup.add_set(225.0, 2)
    end
    if (barbellRow != 0)
      warmup.add_set(225.0, 5)
    else
      warmup.add_set(225.0, target_weight < 305.0 ? 2 : 3)
    end
    if (target_weight < 275.0)
      return warmup.add_set(245.0, 1)
    end
    if (target_weight < 290.0)
      return warmup.add_set(255.0, 1)
    end
    if (target_weight < 301.0)
      return warmup.add_set(265.0, 1)
    end
    if (barbellRow != 0)
      warmup.add_set(265.0, 3)
    elsif (target_weight < 305.0)
      warmup.add_set(265.0, 1)
    elsif (target_weight < 350.0)
      warmup.add_set(265.0, 2)
    else
      warmup.add_set(265.0, 3)
    end
    if (target_weight < 320.0)
      return warmup.add_set(285.0, 1)
    end
    if (target_weight < 330.0)
      return warmup.add_set(295.0, 1)
    end
    if (target_weight < 340.0)
      return warmup.add_set(305.0, 1)
    end
    if (target_weight < 350.0)
      return warmup.add_set(315.0, 1)
    end
    if (barbellRow == 0)
      i = 2
    end
    warmup.add_set(315.0, i)
    if (target_weight < 355.0)
      return warmup.add_set(330.0, 1)
    end
    if (target_weight < 370.0)
      return warmup.add_set(340.0, 1)
    end
    if (target_weight < 380.0)
      return warmup.add_set(345.0, 1)
    end
    if (target_weight < 390.0)
      return warmup.add_set(350.0, 1)
    end
    if (target_weight < 395.0)
      return warmup.add_set(355.0, 1)
    end
    if (target_weight < 400.0)
      return warmup.add_set(360.0, 1)
    end
    return warmup.add_set(365.0, 1)
  end

  def self.default_warmup(exercise, target_weight)
    warmup = WarmUp.new(exercise)
    i = 3
    barbellRow = exercise.name == "Barbell Row" ? 1 : 0
    if ((barbellRow != 0 && target_weight < 105.0) || target_weight < 65.0)
      return warmup
    end
    if (barbellRow != 0 && target_weight < 145.0)
      return warmup.add_set(95.0, 5)
    end
    if (barbellRow == 0)
      warmup.add_set(45.0, 5)
      warmup.add_set(45.0, 5)
      if (target_weight < 95.0)
        return warmup
      end
    end
    if (barbellRow != 0 && target_weight < 160.0)
      return warmup.add_set(115.0, 5)
    end
    if (target_weight < 105.0)
      return warmup.add_set(65.0, 3)
    end
    if (target_weight < 125.0)
      return warmup.add_set(75.0, 3)
    end
    if (target_weight < 135.0)
      return warmup.add_set(85.0, 3)
    end
    if (barbellRow == 0)
      warmup.add_set(95.0, 5)
      if (target_weight < 150.0)
        return warmup.add_set(115.0, 3)
      end
      if (target_weight < 160.0)
        return warmup.add_set(125.0, 3)
      end
      if (target_weight < 185.0)
        return warmup.add_set(135.0, 3)
      end
    end
    if (target_weight < 185.0)
      return warmup.add_set(135.0, 3)
    end
    warmup.add_set(135.0, 5)
    if (target_weight < 200.0)
      return warmup.add_set(165.0, 3)
    end
    if (target_weight < DEADLIFT_INCREMENT_THRESHOLD_LB)
      return warmup.add_set(175.0, 3)
    end
    if (target_weight < 225.0)
      return warmup.add_set(185.0, 3)
    end
    if (barbellRow != 0)
      warmup.add_set(185.0, 5)
    else
      warmup.add_set(185.0, target_weight < 305.0 ? 3 : 5)
    end
    if (target_weight < 240.0)
      return warmup.add_set(205.0, 2)
    end
    if (target_weight < 250.0)
      return warmup.add_set(215.0, 2)
    end
    if (target_weight < 270.0)
      return warmup.add_set(225.0, 2)
    end
    if (barbellRow != 0)
      warmup.add_set(225.0, 5)
    else
      warmup.add_set(225.0, target_weight < 305.0 ? 2 : 3)
    end
    if (target_weight < 275.0)
      return warmup.add_set(245.0, 1)
    end
    if (target_weight < 290.0)
      return warmup.add_set(255.0, 1)
    end
    if (target_weight < 301.0)
      return warmup.add_set(265.0, 1)
    end
    if (barbellRow != 0)
      warmup.add_set(265.0, 3)
    elsif (target_weight < 305.0)
      warmup.add_set(265.0, 1)
    elsif (target_weight < 350.0)
      warmup.add_set(265.0, 2)
    else
      warmup.add_set(265.0, 3)
    end
    if (target_weight < 320.0)
      return warmup.add_set(285.0, 1)
    end
    if (target_weight < 330.0)
      return warmup.add_set(295.0, 1)
    end
    if (target_weight < 340.0)
      return warmup.add_set(305.0, 1)
    end
    if (target_weight < 350.0)
      return warmup.add_set(315.0, 1)
    end
    if (barbellRow == 0)
      i = 2
    end
    warmup.add_set(315.0, i)
    if (target_weight < 355.0)
      return warmup.add_set(330.0, 1)
    end
    if (target_weight < 370.0)
      return warmup.add_set(340.0, 1)
    end
    if (target_weight < 380.0)
      return warmup.add_set(345.0, 1)
    end
    if (target_weight < 390.0)
      return warmup.add_set(350.0, 1)
    end
    if (target_weight < 395.0)
      return warmup.add_set(355.0, 1)
    end
    if (target_weight < 400.0)
      return warmup.add_set(360.0, 1)
    end
    return warmup.add_set(365.0, 1)
  end
end
