module Slugifiable


    def slug
      slug = self.name.downcase.gsub(/\W/,"-")
      self.slug = slug
    end

    def self.find_by_slug(slug)
      self.all.find do |instance|
         instance.slug == slug
      end
    end


end
