###########################################

## Title: Scaled_fill_under_line
## Description: scaled area fill under a time series
## Date: 20221212
  ## Last edited: 20221212
## Contributors: M. Campbell
## Contacts: michelineleecampbell@gmail.com
## Notes: modded from  https://stackoverflow.com/questions/61775003/ggplot2-create-shaded-area-with-gradient-below-curve

###########################################

library(ggplot2)

df <- data.frame(x = 1:1000,
                 y = zoo::rollmean(x = rnorm(1000, mean = 20, sd = 10), k = 10, na.pad = TRUE))
grad_df <- data.frame(yintercept = seq(10, 31, length.out = 1000), 
                       alpha = seq(1,0.3, length.out = 1000))


ggplot(df, aes(x, y)) + 
  geom_area(data = df, fill = "black") +
  geom_hline(data = grad_df, aes(yintercept = yintercept, alpha = alpha),
  size = 0.05, colour = "white") +
  
  geom_line(data = df, colour = "black", size = 0.5) +
  geom_hline(aes(yintercept = 10), alpha = 0.02) + 
  theme_bw()  +
  # geom_point(shape = 16, size = 1, colour = "#80C020") +
  # geom_point(shape = 16, size = 1, colour = "white") +
  # geom_hline(aes(yintercept = min(df$y)), alpha = 0.02) +
  # theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.border       = element_blank(),
        axis.line.x        = element_line(),
        text               = element_text(size = 15),
        plot.margin        = margin(unit(c(20, 20, 20, 20), "pt")),
        axis.ticks         = element_blank(),
        axis.text.y        = element_text(margin = margin(0,15,0,0, unit = "pt"))) +
  scale_alpha_identity() + labs(x="",y="") +
  coord_cartesian(ylim = c(10, 32.5),expand = FALSE)
  # scale_x_date(breaks = "months", expand = c(0.02, 0))

NULL
