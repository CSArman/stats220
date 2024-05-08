library(magick)

slide_text = c("Visualising data from two YouTube channels:\njustmehabibi and Justin Sung",
               "Justmehabibi seems to have, on average, a higher view\nto like ratio while also having shorter video titles",
               "We can see that about 13% of all selected titles incorporate\n emojis into their titles.",
               "All the titles with emojis seem to be soley\n from justmehabibi, Justin Sung seems to not\n use any emojis in his YouTube titles.",
               "Overall, I learned that comedy channels and educational channels have different methods\nof capturing their viewers attention.\nJustmehabibi using shorter titles with imagery like emojis\nseemingly allows for him to gather more of an\ninteractive audience as seen by his view to like ratio. Justin Sung however,\nseems to have longer, and presumably more academic, titles that gather less of an interative audience.")

plot1 = image_read('plot1.png') %>%
  image_resize("600x400") %>%
  image_extent("600x400")

plot2 = image_read('plot2.png') %>%
  image_resize("1200x800") %>%
  image_extent("600x400")

plot3 = image_read('plot3.png') %>%
  image_resize("800x600") %>%
  image_extent("600x400")

slide1 = image_blank(width = 1200, height = 400, color = "black") %>%
  image_annotate(slide_text[1], size = 55, gravity = "center", color = '#fb8982')

textbox2 = image_blank(width = 600, height = 400, color = "black") %>%
  image_annotate(slide_text[2], size = 22, gravity = "center", color = '#38ccd0')

textbox3 = image_blank(width = 600, height = 400, color = "black") %>%
  image_annotate(slide_text[3], size = 22, gravity = "center", color = '#38ccd0')

textbox4 = image_blank(width = 600, height = 400, color = "black") %>%
  image_annotate(slide_text[4], size = 24, gravity = "center", color = '#38ccd0')

final_slide = image_blank(width = 1200, height = 400, color = "black") %>%
  image_annotate(slide_text[5], size = 22, gravity = "center", color = '#fb8982')

slide2 = c(textbox2, plot1) %>%
  image_append()

slide3 = c(textbox3, plot2) %>%
  image_append()

slide4 = c(textbox4, plot3) %>%
  image_append()

gif = c(slide1, slide2, slide3, slide4, final_slide) %>%
  image_animate(delay = 500)


