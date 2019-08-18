require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    page = Nokogiri::HTML(open("fixtures/student-site/index.html"))
    page.css("div.student-card").each do |student|
      student_hash = {
        name: student.css("h4").text,
        location: student.css("p").text,
        profile_url: student.css("a").attribute("href").value
      }
      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    page = Nokogiri::HTML(open(profile_url))
    social_links = page.css("div.social-icon-container a").map{|link| link.attribute("href").value}
    social_links.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = page.css("div.profile-quote").text
    student[:bio] = page.css("p").text
    student
  end

end
