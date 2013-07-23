# -*- coding: utf-8 -*-
require 'bundler/setup'
require 'open-uri'
require 'nokogiri'

class Atnd
  BASE_URL = "http://atnd.org/events/"

  attr_reader :title, :entry

  def initialize(id)
    @id = id
    @url = BASE_URL + @id.to_s
    @entry = 0
    get_information
  end

  def get_information
    html = Nokogiri::HTML(open(@url))
    @title = html.title.gsub(/ : ATND$/, "")
    @entry = html.css('strong.red').first.text
  end

  def make_tweet
    return "「#{@title}」やります! 現在の参加者は#{@entry}人です。 #{@url}"
  end
end
