module LinksHelper
  def show_body(link)
    content = link.body
    content.html_safe
  end
end
