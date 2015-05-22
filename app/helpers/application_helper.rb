module ApplicationHelper
  def gravatar_for(user, size: 260)
    image_tag("https://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}&d=mm", alt: user.username, class: 'gravatar')
  end
end
