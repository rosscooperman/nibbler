module PagesHelper
  def redcloth(text)
    RedCloth.new(text).to_html.html_safe
  end
end