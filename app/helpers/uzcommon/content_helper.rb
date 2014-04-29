module Uzcommon::ContentHelper
  def og_description(description)
    content_for(:og_description) { description }
  end

  def og_image(image)
    content_for(:og_image) { image }
  end

  def title(title)
    content_for(:title) { title }
  end
end