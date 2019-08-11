require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []

    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        profile_url = "#{student.attr('href')}"
        name = student.css(".student-name").text
        location = student.css(".student-location").text

        students << {:name => name, :location => location, :profile_url => profile_url}
      end
    end
    students
  end


  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}

    profile_page.css("div.social-icon-container a").map do |social_link|
      link = social_link.attribute("href").value

      case
      when link.include?("twitter")
        student[:twitter] = link
      when link.include?("linkedin")
          student[:linkedin] = link
      when link.include?("github")
          student[:github] = link
      else
          student[:blog] = link
      end

      student[:profile_quote] = profile_page.css("div.profile-quote").text
      student[:bio] = profile_page.css("div.description-holder p").text
    end
    student
  end

end
