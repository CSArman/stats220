library(tidyverse)
library(jsonlite)
library(magick)

json_data <- fromJSON("pixabay_data.json")
pixabay_photo_data <- json_data$hits

# Having a look at the raw data.
#pixabay_photo_data %>%
  #view()


# is_popular checks if people liked the photo enough to download, with 100000 being my chosen threshold
# hooks_viewers sees if people get hooked by the photo to click and view it with 200000 being my chosen threshold
# user_interaction_score multiplies likes and comments to make a score for photo activity
selected_photos = pixabay_photo_data %>%
  select(pageURL, previewURL, tags, views, downloads, likes, comments) %>%
  mutate(is_popular = ifelse(downloads > 100000, "Popular", "Not Popular"),
         hooks_viewers = ifelse(views > 200000, "yes", "no"),
         user_interaction_score = (likes * comments) / 1000) %>%
  # We then filter out the photos least interacted with, leaving us with 54 results.
  filter(user_interaction_score > 10)

#Writing out selected photos to selected_photos.csv
write_csv(selected_photos, "selected_photos.csv")

# Calculating means and median values for downloads, views and comments
mean_downloads = mean(selected_photos$downloads) %>%
  round()

median_views = median(selected_photos$views) %>%
  round()

mean_comments = mean(selected_photos$comments) %>%
  round()


# We want to see the avg user interaction score for popular and non-popular photos
summary_value = selected_photos %>%
  group_by(is_popular) %>%
  summarise(avg_UI_score = round(mean(user_interaction_score))) %>%
  print()
  
# Setup the images for the gif
image_1 = image_read(selected_photos$previewURL[1]) %>%
  image_extent("200x200")

image_2 = image_read(selected_photos$previewURL[2]) %>%
  image_extent("200x200")

image_3 = image_read(selected_photos$previewURL[3]) %>%
  image_extent("200x200")

image_4 = image_read(selected_photos$previewURL[4]) %>%
  image_extent("200x200")

# Setup the animation of the images
gif_normal = image_resize(c(image_1, image_2, image_3, image_4)) %>%
  image_morph(frames = 24) %>%
  image_animate(fps = 5, delay = 20, optimize = TRUE)

# Write the gif to my_photos.gif
image_write(gif_normal, "my_photos.gif")


# Creative GIF creation:

# Setting up a random seed, to see a different set of gifs animated, change the seed.
set.seed(2199)

# Initialise a vector
random_values = c()

#Using a for loop to create 4 random values and add them into my vector.
for (i in 1:4){
  random_value = runif(1, min = 1, max = 54)
  random_values = c(random_values, round(random_value))
}

# Setup the random images
random_image_1 = image_read(selected_photos$previewURL[random_values[1]]) %>%
  image_extent("200x200")

random_image_2 = image_read(selected_photos$previewURL[random_values[2]]) %>%
  image_extent("200x200")

random_image_3 = image_read(selected_photos$previewURL[random_values[3]]) %>%
  image_extent("200x200")

random_image_4 = image_read(selected_photos$previewURL[random_values[4]]) %>%
  image_extent("200x200")

# Setup the animation of the random images
gif_random = image_resize(c(random_image_1, random_image_2, random_image_3, random_image_4)) %>%
  image_morph(frames = 24) %>%
  image_animate(fps = 5, delay = 20, optimize = TRUE)

image_write(gif_random, "random_photos.gif")