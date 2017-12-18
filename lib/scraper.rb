require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open("./fixtures/student-site/index.html")
    students = Nokogiri::HTML(html)
    students_array = []

    students.css("div .student-card").each do |student|
      hash = {}
      hash[:name] = student.css("h4.student-name").text
      hash[:location] = student.css("p.student-location").text
      hash[:profile_url] = student.css("a").attribute("href").text

      students_array << hash
    end
    students_array
  end

  def self.website_name(array)
    hash = {}
    array.each do |n|
      if n.include?("twitter")
        hash[:twitter] = n
      elsif n.include?("linkedin")
        hash[:linkedin] = n
      elsif n.include?("github")
        hash[:github] = n
      else
        hash[:blog] = n
      end
    end
    hash
  end



  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    profile = Nokogiri::HTML(html)
    profile_hash = {}

    items = profile.css("div .vitals-container a").map do |vitals|
      vitals.attribute("href").text
    end
    profile_hash = website_name(items)

    profile_hash[:profile_quote] = profile.css("div .profile-quote").text
    profile_hash[:bio] = profile.css("div .description-holder p").text

    profile_hash
  end



end
