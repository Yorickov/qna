module LinksHelper
  def show_body(link)
    content = link.load_body
    to_html(content)
  end

  private

  def to_html(content)
    content.html_safe
  end
end
