module ApplicationHelper
  def gravatar_for(user, size: 260)
    secure_host = "https://secure.gravatar.com/avatar"
    options = "s=#{size}&d=mm"
    image_tag "#{secure_host}/#{user.gravatar_id}?#{options}",
              alt: user.username,
              class: "gravatar"
  end
end
