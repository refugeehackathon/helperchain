module ApplicationHelper
  def active_li_link_to t, path, *args
    cls = ""
    if current_page? path
      cls = "active"
    end
    "<li class=\"#{cls}\">#{link_to t, path, *args}</li>".html_safe
  end
end
