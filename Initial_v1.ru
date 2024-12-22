require 'selenium-webdriver'
require 'rainbow/refinement'
using Rainbow

# Loop for 100 iterations
100.times do |i|
  # Print the current iteration
  puts "Starting iteration #{i + 1}...".cyan

  # Initialize the WebDriver
  driver = Selenium::WebDriver.for :chrome

  # Variable for random sleep time
  rantime = rand(5..7)

  begin
    # Open the Google homepage
    driver.get 'https://google.com'

    # Wait for the search bar to be present
    wait = Selenium::WebDriver::Wait.new(timeout: 10) # 10 seconds timeout
    search_box = wait.until { driver.find_element(id: 'APjFqb') }

    # Type "stylo collection" into the search box and hit Enter
    search_box.send_keys('stylo collection', :enter)

    # Loop through the result pages to find the desired URL
    found = false
    until found
      # Wait for the search results to load
      wait.until { driver.find_elements(css: 'a').size > 0 }

      # Check if "stylocollections.net" is present in the results
      links = driver.find_elements(css: 'a')
      links.each do |link|
        if link.attribute('href')&.include?('stylocollections.net')
          puts "Found stylocollections.net! Navigating to the page...".green
          link.click
          found = true
          break
        end
      end

      # If not found, navigate to the next page
      unless found
        next_button = driver.find_element(css: 'a#pnnext') # Next button ID
        if next_button.displayed?
          next_button.click
          sleep(2) # Optional: Wait briefly for the next page to load
        else
          puts "Reached the end of search results. URL not found.".purple
          break
        end
      end
    end

    # Add additional actions if the page is found
    if found
      puts "Successfully navigated to stylocollections.net".green
      puts "Random sleep time: #{rantime}".yellow
      sleep(rantime)

      # Wait for the page to load
      wait.until { driver.find_elements(css: 'a').size > 0 }

      # Get all links on the current page
      all_links = driver.find_elements(css: 'a').map { |link| link.attribute('href') }.compact
      puts "Total links found: #{all_links.size}".red

      # Randomly select a link
      if all_links.any?
        random_link = all_links.sample
        puts "Randomly selected link: #{random_link}".blue

        # Re-run the random function
        rantime = rand(5..7)

        # Navigate to the randomly selected link
        driver.navigate.to(random_link)
        puts "Navigated to the randomly selected link.".yellow
        puts "Random sleep time: #{rantime}".yellow
        sleep(rantime)
      else
        puts "No links found on the page.".red
      end
    end

  ensure
    # Quit the driver
    driver.quit
  end

  puts "Completed iteration #{i + 1}.".cyan
end

puts "All 100 iterations completed.".green
