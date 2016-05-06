module ApplicationHelper
  VIDEOS=[
    "ua8oObEPptQ",
    "txuWGoZF3ew",
  ]
  def gravatar_for(user, size: 260)
    secure_host = "https://secure.gravatar.com/avatar"
    options = "s=#{size}&d=mm"
    image_tag "#{secure_host}/#{user.gravatar_id}?#{options}",
      alt: user.username,
      class: "gravatar"
  end

  def search_form(
    id: "search-form",
    path: @search_path || dashboard_path,
    remote: @remote_search
  )
    form_tag path, id: id, method: :get, remote: remote do
      search_field_tag :q, params[:q], placeholder: t(:search)
    end
  end

  def random_video
    video = VIDEOS.sample
    iframe = content_tag(:iframe, "", width: 560, height: 315, src: "https://www.youtube.com/embed/#{video}", frameborder: 0, allowfullscreen: true)
    content_tag(:div, iframe, class: "flex-video")
  end
end
