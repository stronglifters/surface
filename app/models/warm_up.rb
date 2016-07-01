class WarmUp
  attr_reader :exercise, :sets, :target_weight

  def initialize(exercise, target_weight)
    @sets = []
    @exercise = exercise
    @target_weight = target_weight
    case exercise.name
    when "Deadlift"
      dead_lift_warmup
    when "Barbell Row"
      barbell_row_warmup
    else
      default_warmup
    end
  end

  private

  def add_set(weight, repetitions)
    @sets << WarmUpSet.new(
      exercise: exercise,
      target_weight: weight,
      target_repetitions: repetitions,
    )
    self
  end

  def dead_lift_warmup
    return self if target_weight < 155.0
    return add_set(135.0, 5) if target_weight < 175.0
    add_set(135.0, 5)
    return add_set(165.0, 5) if target_weight < 200.0
    return add_set(175.0, 5) if target_weight < 220.0
    return add_set(185.0, 5) if target_weight < 225.0
    add_set(185.0, 5)
    return add_set(205.0, 5) if target_weight < 240.0
    return add_set(215.0, 5) if target_weight < 250.0
    return add_set(225.0, 5) if target_weight < 270.0
    add_set(225.0, 5)
    return add_set(245.0, 5) if target_weight < 275.0
    return add_set(255.0, 5) if target_weight < 290.0
    return add_set(265.0, 5) if target_weight < 301.0
    add_set(265.0, 3)
    return add_set(285.0, 1) if target_weight < 320.0
    return add_set(295.0, 1) if target_weight < 330.0
    return add_set(305.0, 1) if target_weight < 340.0
    return add_set(315.0, 1) if target_weight < 350.0
    add_set(315.0, 3)
    return add_set(335.0, 1) if target_weight < 360.0
    return add_set(340.0, 1) if target_weight < 370.0
    return add_set(345.0, 1) if target_weight < 380.0
    return add_set(350.0, 1) if target_weight < 390.0
    return add_set(355.0, 1) if target_weight < 395.0
    return add_set(360.0, 1) if target_weight < 400.0
    add_set(365.0, 1)
  end

  def barbell_row_warmup
    return self if target_weight < 105.0 || target_weight < 65.0
    return add_set(95.0, 5) if target_weight < 145.0
    return add_set(115.0, 5) if target_weight < 160.0
    return add_set(65.0, 3) if target_weight < 105.0
    return add_set(75.0, 3) if target_weight < 125.0
    return add_set(85.0, 3) if target_weight < 135.0
    return add_set(135.0, 3) if target_weight < 185.0
    add_set(135.0, 5)
    return add_set(165.0, 3) if target_weight < 200.0
    return add_set(175.0, 3) if target_weight < 220.0
    return add_set(185.0, 3) if target_weight < 225.0
    add_set(185.0, 5)
    return add_set(205.0, 2) if target_weight < 240.0
    return add_set(215.0, 2) if target_weight < 250.0
    return add_set(225.0, 2) if target_weight < 270.0
    add_set(225.0, 5)
    return add_set(245.0, 1) if target_weight < 275.0
    return add_set(255.0, 1) if target_weight < 290.0
    return add_set(265.0, 1) if target_weight < 301.0
    add_set(265.0, 3)
    return add_set(285.0, 1) if target_weight < 320.0
    return add_set(295.0, 1) if target_weight < 330.0
    return add_set(305.0, 1) if target_weight < 340.0
    return add_set(315.0, 1) if target_weight < 350.0
    add_set(315.0, 3)
    return add_set(330.0, 1) if target_weight < 355.0
    return add_set(340.0, 1) if target_weight < 370.0
    return add_set(345.0, 1) if target_weight < 380.0
    return add_set(350.0, 1) if target_weight < 390.0
    return add_set(355.0, 1) if target_weight < 395.0
    return add_set(360.0, 1) if target_weight < 400.0
    add_set(365.0, 1)
  end

  def default_warmup
    return self if target_weight < 65.0
    add_set(45.0, 5)
    add_set(45.0, 5)
    return self if target_weight < 95.0
    return add_set(65.0, 3) if target_weight < 105.0
    return add_set(75.0, 3) if target_weight < 125.0
    return add_set(85.0, 3) if target_weight < 135.0
    add_set(95.0, 5)
    return add_set(115.0, 3) if target_weight < 150.0
    return add_set(125.0, 3) if target_weight < 160.0
    return add_set(135.0, 3) if target_weight < 185.0
    return add_set(135.0, 3) if target_weight < 185.0
    add_set(135.0, 5)
    return add_set(165.0, 3) if target_weight < 200.0
    return add_set(175.0, 3) if target_weight < 220.0
    return add_set(185.0, 3) if target_weight < 225.0
    add_set(185.0, target_weight < 305.0 ? 3 : 5)
    return add_set(205.0, 2) if target_weight < 240.0
    return add_set(215.0, 2) if target_weight < 250.0
    return add_set(225.0, 2) if target_weight < 270.0
    add_set(225.0, target_weight < 305.0 ? 2 : 3)
    return add_set(245.0, 1) if target_weight < 275.0
    return add_set(255.0, 1) if target_weight < 290.0
    return add_set(265.0, 1) if target_weight < 301.0
    if target_weight < 305.0
      add_set(265.0, 1)
    elsif target_weight < 350.0
      add_set(265.0, 2)
    else
      add_set(265.0, 3)
    end
    return add_set(285.0, 1) if target_weight < 320.0
    return add_set(295.0, 1) if target_weight < 330.0
    return add_set(305.0, 1) if target_weight < 340.0
    return add_set(315.0, 1) if target_weight < 350.0
    add_set(315.0, 2)
    return add_set(330.0, 1) if target_weight < 355.0
    return add_set(340.0, 1) if target_weight < 370.0
    return add_set(345.0, 1) if target_weight < 380.0
    return add_set(350.0, 1) if target_weight < 390.0
    return add_set(355.0, 1) if target_weight < 395.0
    return add_set(360.0, 1) if target_weight < 400.0
    add_set(365.0, 1)
  end
end
