module ErrorHandleable
  extend ActiveSupport::Concern

  included do
    before_action do |controller|
      if controller.send(:current_user)
        append_exception_data({
          current_user: current_user
        })
      end
    end
  end

  private

  def append_exception_data(data = {})
    request.env["exception_notifier.exception_data"] = data
  end
end
