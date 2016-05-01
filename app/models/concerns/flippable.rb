module Flippable
  extend ActiveSupport::Concern

  def flipper_id
    id
  end
end
