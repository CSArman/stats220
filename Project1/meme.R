# Initialising the libraries required.
library(magick)
library(tidyverse)

meme_text = c("Updating Arch Linux", "Updating Linux Mint", "Updating Windows", "Updating Gentoo")


# Initialising the different phases of Mr Incredible's face.
image_phase_1 = image_read("https://static.wikia.nocookie.net/the-uncanny-incredible/images/5/5f/Mibu_phase_1_%28original_hd%29.webp") %>%
  image_extent("600x600")

image_phase_2 = image_read("https://static.wikia.nocookie.net/the-uncanny-incredible/images/e/e7/Phase_2_HD.jpg/revision/latest?cb=20230619071456") %>%
  image_extent("600x600")

image_phase_3 = image_read("https://static.wikia.nocookie.net/the-uncanny-incredible/images/a/ad/7hd.png/revision/latest?cb=20230322173450") %>%
  image_extent("600x600")

image_phase_4 = image_read("https://static.wikia.nocookie.net/the-uncanny-incredible/images/7/71/Higher_definition_image%2C_as_seen_in_m%C3%BAsicos_C%C3%ADnicos%E2%80%99s_video..jpg/revision/latest/scale-to-width-down/1000?cb=20220215164526") %>%
  image_extent("600x600")






# Creating the textbox for each image

phase_1_textbox = image_blank(width = 600, height = 600, color = "black") %>%
  image_annotate(meme_text[1], size = 60, gravity = "center", color = 'yellow')

phase_2_textbox = image_blank(width = 600, height = 600, color = "black") %>%
  image_annotate(meme_text[2], size = 60, gravity = "center", color = 'yellow')

phase_3_textbox = image_blank(width = 600, height = 600, color = "black") %>%
  image_annotate(meme_text[3], size = 60, gravity = "center", color = 'yellow')

phase_4_textbox = image_blank(width = 600, height = 600, color = "black") %>%
  image_annotate(meme_text[4], size = 60, gravity = "center", color = 'yellow')



# Stacking the textbox over the appropriate image

frame_1 = c(phase_1_textbox, image_phase_1) %>%
  image_append(stack = TRUE)
frame_2 = c(phase_2_textbox, image_phase_2) %>%
  image_append(stack = TRUE)
frame_3 = c(phase_3_textbox, image_phase_3) %>%
  image_append(stack = TRUE)
frame_4 = c(phase_4_textbox, image_phase_4) %>%
  image_append(stack = TRUE)


# Creating the animation with morphed frames
animation = image_resize(c(frame_1, frame_2, frame_3, frame_4)) %>%
  image_morph(frames = 24) %>%
  image_animate(fps = 5, delay = 12, optimize = TRUE)

# Running the animation itself
animation

# Writing it as a gif
image_write(animation, "my_animation.gif")

# Writing frame 1 as my meme png
image_write(frame_1, "my_meme.png")
