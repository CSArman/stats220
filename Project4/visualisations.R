library(tidyverse)
# Has function to detect if emojis are present
library(emoji)
# Functions that allows two full plots put next to each other for comparison
library(patchwork)

youtube_data = read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRBhZuCvKPJNIfS8ZMmK1kOUI8OMvMP3Hkq5VU7n5SVYI7zzO26RkkeZlx-Aoz_aOaRQMyvTxg06Wdm/pub?output=csv")

youtube_more_data = youtube_data %>%
  mutate(title_length = str_count(title),
         # Checks to see if emoji is in the title or not
         title_has_emojis = ifelse(emoji_count(title) >= 1, "Yes", "No"),
         view_to_like_ratio = round((viewCount / likeCount))) %>%
  arrange(desc(view_to_like_ratio))


# Checking the percentage of how many of the titles have emojis
emojis_both_channels = youtube_more_data %>%
  group_by(title_has_emojis) %>%
  summarise(Percent = n()/nrow(.) * 100) %>%
  arrange(desc(title_has_emojis))

emojis_justinsung = youtube_more_data %>%
  arrange(channelName) %>%
  slice(1:100) %>%
  group_by(title_has_emojis) %>%
  summarise(Percent = n()/nrow(.) * 100) %>%
  arrange(desc(title_has_emojis))

emojis_justmehabibi = youtube_more_data %>%
  arrange(desc(channelName)) %>%
  slice(1:100) %>%
  group_by(title_has_emojis) %>%
  summarise(Percent = n()/nrow(.) * 100) %>%
  arrange(desc(title_has_emojis))

# Pie chart showing the percentage of titles that have titles
both_channels_pie_chart = ggplot(data = emojis_both_channels, mapping = aes(x = "", y = Percent, fill = title_has_emojis)) +
  geom_bar(width = 1, stat = "identity") +
  scale_y_continuous(breaks = round(cumsum(rev(emojis_both_channels$Percent)), 1)) +
  coord_polar("y", start = 0) + 
  labs(title = 'Both Channels - Percentage of titles that have Emojis')

justinsung_pie_chart = ggplot(data = emojis_justinsung, mapping = aes(x = "", y = Percent, fill = title_has_emojis)) +
  geom_bar(width = 1, stat = "identity") +
  scale_y_continuous(breaks = round(cumsum(rev(emojis_justinsung$Percent)), 1)) +
  coord_polar("y", start = 0) + 
  labs(title = 'Justin Sung - % of titles that have Emojis')

justmehabibi_pie_chart = ggplot(data = emojis_justmehabibi, mapping = aes(x = "", y = Percent, fill = title_has_emojis)) +
  geom_bar(width = 1, stat = "identity") +
  scale_y_continuous(breaks = round(cumsum(rev(emojis_justmehabibi$Percent)), 1)) +
  coord_polar("y", start = 0) + 
  labs(title = 'justmehabibi - % of titles that have Emojis')


# Stitching two plots together
combined_pie_charts = justmehabibi_pie_chart + justinsung_pie_chart + plot_layout(guides = "collect")

# Creating the box plots for title lengths and view to like ratios. 
comparing_title_lengths = ggplot(data = youtube_more_data,
       aes(x = title_length, 
           y = reorder(channelName, -title_length),
           colour = channelName)) +
  geom_jitter(height = 0.2) +
  geom_boxplot(fill = "transparent") +
  labs(y = "Channels") +
  guides(colour = "none") +
  theme_minimal()

comparing_view_to_like_ratios = ggplot(data = youtube_more_data,
                                 aes(x = view_to_like_ratio, 
                                     y = reorder(channelName, -view_to_like_ratio),
                                     colour = channelName)) +
  geom_jitter(height = 0.2) +
  geom_boxplot(fill = "transparent") +
  labs(y = "Channels") +
  guides(colour = "none") +
  theme_minimal()


combined_ratio_and_title_comparisons = comparing_view_to_like_ratios + comparing_title_lengths + plot_layout(guides = "collect")


