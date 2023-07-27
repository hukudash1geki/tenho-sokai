require 'mechanize'

agent = Mechanize.new
page = agent.get('https://tenhou.net/sc/raw/')

# CSSセレクタを使用して、"href"属性に"dat"を含む<a>要素を見つける
dat_links = page.search('a[href*="dat"]')
urls = []

elements.esch do |ele|
  urls << ele.get_attribute(:href)
  puts ele.get_attribute(:href)
  sleep 1
end