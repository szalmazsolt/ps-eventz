module LikesHelper

  def like_or_unlike_button(like, event)
    if !like
      # button_to always uses the POST http request
      button_to "Like", event_likes_path(event)
    else
      button_to "Unlike", event_like_path(event, like), method: :delete
    end
  end

end
