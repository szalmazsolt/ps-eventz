module EventsHelper

  def price_or_free(event)
    if event.free?
      "Free"
    else
      number_to_currency(event.price, precision: 0)
    end
  end

  def format_datetime(event)
    event.starts_at.strftime("%Y. %m. %d. at %H:%M")
  end
end
