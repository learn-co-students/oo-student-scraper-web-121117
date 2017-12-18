require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index = Nokogiri::HTML(html)

    students_array = []
    # binding.pry
    index.css("div.roster-cards-container div.student-card").each do |studentCard|
      students_array << {
        :name => studentCard.css("h4.student-name").text,
        :location => studentCard.css("p.student-location").text,
        :profile_url => studentCard.css("a").attribute("href").text
      }
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)

    profile_hash = {}

    profile.css("div.social-icon-container a").each do |link|
      i = link.attribute("href").text
        case
        when i.include?("twitter")
          profile_hash[:twitter] = i
        when i.include?("linkedin")
          profile_hash[:linkedin] = i
        when i.include?("github")
          profile_hash[:github] = i
        else
          profile_hash[:blog] = i
        end
    end

    profile_hash[:profile_quote] = profile.css("div.profile-quote").text
    profile_hash[:bio] = profile.css("div.description-holder p").text
    profile_hash
    # binding.pry
  end
end

Scraper.scrape_profile_page("./fixtures/student-site/students/joe-burgess.html")

# link.css("a").attribute("href").text