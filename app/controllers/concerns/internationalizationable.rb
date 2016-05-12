module Internationalizationable
  extend ActiveSupport::Concern

  included do
    around_action :with_time_zone, if: :current_user
    around_action :with_locale
  end

  private

  def with_time_zone
    Time.use_zone(current_user.time_zone) { yield }
  end

  def with_locale
    I18n.with_locale(params[:locale]) { yield }
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end
end
