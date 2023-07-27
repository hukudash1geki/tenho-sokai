require 'selenium-webdriver'

class TenhouScraper
  def self.get_links_with_dat_sca(url)
    log_urls = []

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    driver = Selenium::WebDriver.for :chrome, options: options

    begin
      driver.get(url)
      wait = Selenium::WebDriver::Wait.new(timeout: 30)
      wait.until { driver.execute_script('return document.readyState') == 'complete' }

      page_source = driver.page_source
      doc = Nokogiri::HTML(page_source)

      doc.css("a").each do |link|
        href = link['href']
        if href && href.start_with?("dat/")
          absolute_url = URI.join(url, href)
          log_urls << absolute_url.to_s
          sleep 1
        end
      end
    rescue StandardError => e
      puts "Error occurred while scraping: #{e.message}"
    ensure
      driver.quit
    end

    puts "log_urls: #{log_urls.inspect}"
    log_urls
  end
end





