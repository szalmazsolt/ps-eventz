module RegistrationsHelper

  def register_or_sold_out(event)
    p "Helper runs!!!!!!!!!!"
    if event.sold_out?
      p "Soooold out"
      content_tag(:span, "Sold Out", class: "sold-out")
    else
      link_to "Register", new_event_registration_path(event), class: "register"
    end
  end
end
