module WorkoutsHelper
  def filter_params
    params.permit(:since, :exercise)
  end

  def filter_params_hash(options = {})
    filter_params.to_hash.merge(options).with_indifferent_access
  end
end
