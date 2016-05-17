module ControllerHelpers
  # returns address that request came from, either with or without params included
  # Using HTTP_REFERER, because we don't know if the page we came from is properties/all or properties/archived etc
  # split('?')[0] gets rid of the query string and just goes back to the vanilla page
  # :back returns to the previous page, but includes the full query string, so can't use that :(
  # --- can't think of a better way to do this than this way, despite how long winded it seems!
  def back_address param_string
    return "#{request.env['HTTP_REFERER'].split('?')[0]}?#{param_string}"
  end
end
