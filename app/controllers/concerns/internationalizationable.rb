module Internationalizationable
  extend ActiveSupport::Concern

  included do
    around_action :with_time_zone, if: :current_user
    around_action :with_locale
  end

  protected

  def translate(key)
    I18n.translate("#{params[:controller]}.#{params[:action]}#{key}")
  end

  private

  def with_time_zone
    Time.use_zone(current_user.time_zone) { yield }
  end

  def with_locale
    I18n.with_locale(current_locale) { yield }
  end

  def current_locale(locales = I18n.available_locales)
    params[:locale] || http_accept_language.compatible_language_from(locales)
  end
end
