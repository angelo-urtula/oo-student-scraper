require 'open-uri'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))


    doc.css(".student-card").collect do |studentcard|
        {
        :name => studentcard.css("h4.student-name").text,
        :location => studentcard.css("p.student-location").text,
        :profile_url => studentcard.css("a").first["href"]
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

links = Hash[
  *doc.search('a').map {|a|
[
  a["href"],
  a.content
]}.flatten
]

name = doc.css(".profile-name").text.split[0].downcase
    {
      :twitter => links.keys.find {|link| /twitter/ =~ link},
      :linkedin => links.keys.find {|link| /linkedin/ =~ link},
      :github => links.keys.find {|link| /github/ =~ link},
      :blog => links.keys.find {|link| /#{name}(?!-)/ =~ link},
      :profile_quote => doc.css(".profile-quote").text,
      :bio => doc.css("p").text
}.delete_if { |key, value| value.to_s.strip == '' }
  end

end

