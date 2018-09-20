module Slugifiable

  def slugify(object)
    slug = self.name.downcase.gsub(/\W/,"-")
    self.slug = slug
  end

end
