library(tidyverse)

# Reading data from my CSV and putting into the data frame learning_data
learning_data = read_csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vQkKN1kY2z2FC2C8sjOWu8ihVRI0J7AwMAFA9ha2qEh4eVHCRY4W8yp0w2Ofpx06mKm065LWRnK9_-l/pub?output=csv')

# Renaming my variables
renamed_data = learning_data %>%
  rename(date = 1,
         days_exercising = 2,
         hours_exercising = 3,
         gym_attendance = 4,
         music = 5,
         exercise_motivation = 6)

#Piping the data frame to make bar graphs
days_exercising_bar = renamed_data %>% 
  ggplot() + geom_bar(aes(x = days_exercising), col = "purple")

hours_exercising_bar = renamed_data %>% 
  ggplot() + geom_bar(aes(x = hours_exercising), col = "green")

gym_attendance_bar = renamed_data %>%
  ggplot() + geom_bar(aes(x = gym_attendance), col = "red")

# Showing the gym attendance bar graph
gym_attendance_bar

# Finding the mode for days/hours excercised and gym attendance
mode_days_exercising = renamed_data %>%
  count(days_exercising) %>%
  filter(n == max(n)) %>%
  pull(days_exercising)

mode_hours_exercising = renamed_data %>%
  count(hours_exercising) %>%
  filter(n == max(n)) %>%
  pull(hours_exercising)

mode_gym_attendance = renamed_data %>%
  count(gym_attendance) %>%
  filter(n == max(n)) %>%
  pull(gym_attendance)

# Running the mode functions to see the mode
mode_gym_attendance
mode_days_exercising
mode_hours_exercising