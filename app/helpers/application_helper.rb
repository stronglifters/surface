module ApplicationHelper
  def gravatar_for(user, size: 260)
    secure_host = "https://secure.gravatar.com/avatar"
    options = "s=#{size}&d=mm"
    image_tag "#{secure_host}/#{user.gravatar_id}?#{options}",
      alt: user.username,
      class: "gravatar"
  end

  def search_form(search_path: @search_path || dashboard_path, remote: @remote_search)
    form_tag search_path, id: "search-form", method: :get, remote: remote do
      search_field_tag :q, params[:q], placeholder: t(:search)
    end
  end
end
