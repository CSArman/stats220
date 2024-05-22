library(tidyverse)
library(rvest)

# My data context is the job listings for software development.

# Useful webpage information to collect:
#  - Company names
#  - Job locations
#  - Full time or part time
#  - Skills listed on job page
#  - Job post dates

# I wanted to web scrape Linkedin but the robots.txt page disallowed looking at the webpage information I was looking for.
# I tried trademe jobs and it seemed to allow /a/it/programming-development in robots.txt and was not prohibited in the terms of service but it gives ERROR 429 when accessing the URL.
# I tried seek and it allowed job searches in robots.txt and in the terms of service.


url = "https://www.seek.co.nz/Software-Engineer-jobs"

page = read_html(url)

# Find ids and classes avaliable to use.
list = page %>%
  html_nodes("*") %>%
  html_attr("id") %>%
  unique()

contract_or_full_time = page %>%
  html_elements("p") %>%
  html_text2()

job_title = page %>%
  html_elements("h3") %>%
  html_text2()


job_listing_dates = page %>%
  html_elements("[data-automation='jobListingDate']") %>%
  html_text2()

number_job_results = page %>%
  html_elements("#SearchSummary") %>%
  html_text2()



number_job_results
job_listing_dates
job_title
contract_or_full_time