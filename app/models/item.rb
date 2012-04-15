require 'nokogiri'
require 'open-uri'

class Item < ActiveRecord::Base
  attr_accessible :author, :body, :published_at, :title, :url
  def self.create_from_url url
    doc = Nokogiri::HTML(open(url))
    item = Item.new
    item.title = extract_title doc
    item.body = extract_body doc
    item.author = extract_author doc
  end

  private
  def self.extract_title doc
    doc.css('h1').first.content
  end

  def self.extract_body doc
    lines = doc.css('p').to_a.to_hash_values{ |p| p.content.length }
    longest_line = lines[lines.keys.sort.reverse.first]
    self.parent_element(longest_line).content
  end

  def self.extract_author doc
    /.*By ([\w\s']+)\n\d+/.match(doc.content)[1]
  end

  def self.parent_element element
    return element if element.parent.nil?
    ["div", "td"].include?(element.name) ? element : self.parent_element(element.parent)
  end
end


class Array
  def to_hash_values(&block)
    Hash[*self.collect { |v| [block.call(v), v] }.flatten]
  end
end