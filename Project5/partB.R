library(tidyverse)
library(rvest)

# I have selected for my minister: Hon Chris Bishop

# Features of the text:
# - The amount of words per paragraph seems to be around 60
# - The number of words per sentence seems to be around 15
# - The length of the words mostly seem to be around 5
# - There seems to be a lot of quotation paragraphs of opinions on certain matters from different people
# - There also seems to be recommendations set out in bullet points
# - Majority of sentences and paragraphs are formal like a report.
# - There is a lot of words like 'fiscal' or 'budget' and other monetary terms used throughout his releases.

url <- "https://www.beehive.govt.nz/minister/hon-chris-bishop"

pages <- read_html(url) %>%
  html_elements(".release__wrapper") %>%
  html_elements("h2") %>%
  html_elements("a") %>%
  html_attr("href") %>%
  paste0("https://www.beehive.govt.nz", .)


page_url <- pages[1]
print(page_url)

page <- read_html(page_url)

release_title <- page %>%
  html_elements(".article__title") %>%
  html_text2()

release_content <- page %>%
  html_elements(".prose.field.field--name-body.field--type-text-with-summary.field--label-hidden.field--item") %>%
  html_text2()
# Both work


get_release <- function(page_url){
  Sys.sleep(1)
  # print the page_url so if things go wrong
  # we can see which page caused issues
  print(page_url)
  page <- read_html(page_url)
  
  # add code to scrape the release title and release content
  release_title <- page %>%
    html_elements(".article__title") %>%
    html_text2()
  
  release_content <- page %>%
    html_elements(".prose.field.field--name-body.field--type-text-with-summary.field--label-hidden.field--item") %>%
    html_text2()
  
  # add code to return a tibble created using these data objects
  tibble(words = release_content, release_title)
}

release_data <- map_df(pages, get_release)



extra_data = release_data %>%
  mutate(title_length = str_count(release_title),
         number_of_sentences = str_count(words, "\\."),
         includes_recommendations = str_detect(str_to_lower(words), 'recommend'),
         includes_monetary_info = str_detect(str_to_lower(words), "budget|fiscal|finance|deposit|grant|fund"))

mean_title_length = mean(extra_data$title_length)

mean_num_sentences = mean(extra_data$number_of_sentences)

counts_includes_recommendation = extra_data %>%
  group_by(includes_recommendations) %>%
  summarise(count = n())


# 30% include recommmendations
percentage_includes_recommendation = counts_includes_recommendation %>%
  filter(includes_recommendations == TRUE) %>%
  pull(count) / sum(counts_includes_recommendation$count) * 100


counts_includes_monetary_info = extra_data %>%
  group_by(includes_monetary_info) %>%
  summarise(count = n())


# 50% include monetary info
percentage_includes_monetary_info = counts_includes_monetary_info %>%
  filter(includes_monetary_info == TRUE) %>%
  pull(count) / sum(counts_includes_monetary_info$count) * 100



percentage_includes_recommendation
percentage_includes_monetary_info
mean_title_length
mean_num_sentences
