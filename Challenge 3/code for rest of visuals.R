# regression model to the grouped data
model <- glm(total_false_mean ~ weight_mean + timeelapsed1_mean + timeelapsed2_mean, data = grouped_df)
# Calculate predicted counts for the grouped data
grouped_df$predicted_counts <- predict(model, newdata = grouped_df, type = "response")
library(ggplot2)
ggplot(grouped_df, aes(x = weight_mean, y = predicted_counts)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Predicted Counts vs. Mean Weight",
       x = "Weight of Produced Container",
       y = "Predicted False Counts")
grouped_df$predicted_counts <- predict(model, newdata = grouped_df, type = "response")

# Calculate predicted of false quality by weight
grouped_df$predicted_percent <- grouped_df$predicted_counts / nrow(df[df$product == grouped_df$product,]) * 100
ggplot(grouped_df, aes(x = weight_mean, y = predicted_percent)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  xlab("Weight (g)") +
  ylab("Predicted Percentage of False Quality") +
  ggtitle("Predicted Percentage of False Quality by Weight") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())


##Products Produced by hour vs quality
merged_data <- quality_false_df_by_hour %>%
  left_join(products_by_hour, by = "hour")
merged_data <- merged_data %>%
  filter(row_number() != 12)
library(ggplot2)
ggplot(merged_data, aes(x = products_produced, y = total_false)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Products Produced by Hour vs Quality",
       x = "Number of Products Produced in any Certain Hour", y = "Quality False Counts") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
correlation <- cor(merged_data$products_produced, merged_data$total_false)
correlation


## Quality by cycle 
quality_variables <- cleaned_data %>%
  select(quality401, quality402, quality405, quality406, quality407_L)
# Count the number of FALSE 
false_counts <- sapply(quality_variables[, c("quality401", "quality402", "quality405", "quality407_L")], function(x) sum(x == FALSE, na.rm = TRUE))
false_df <- data.frame(variable = names(false_counts), count = false_counts)
my_colors <- c("steelblue", "red", "forestgreen", "pink")
# barplot
ggplot(false_df, aes(x = variable, y = count, fill = variable)) +
  geom_col() +
  scale_fill_manual(values = my_colors) +
  xlab("Cycle") +
  ylab("Quality check False Counts") +
  ggtitle("Quality by Cycle") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())


##Cycle time and boxplots
library(ggplot2)
library(gridExtra)

#clean
data2_filtered_402 <- data2 %>% 
  select(quality402, cycleTime402) %>% 
  filter(!is.na(quality402) & !is.na(cycleTime402))

#boxplot cycle 402
plot_402 <- ggplot(data2_filtered_402, aes(x = "402", y = ifelse(cycleTime402 > 0, cycleTime402, NA_real_), fill = quality402)) +
  geom_boxplot() +
  labs(x = "Cycle", y = "Cycle Times", title = "Cycle 402 Times vs Quality") +
  theme_classic() +
  theme(plot.background = element_rect(fill = "white"))

#filter
data2_filtered_405 <- data2 %>% 
  select(quality405, cycleTime405) %>% 
  filter(!is.na(quality405) & !is.na(cycleTime405)) %>% 
  rename(quality = quality405, cycleTime = cycleTime405)

#boxplot 405
plot_405 <- ggplot(data2_filtered_405, aes(x = "405", y = ifelse(cycleTime > 0, cycleTime, NA_real_), fill = quality)) +
  geom_boxplot() +
  labs(x = "Cycle", y = "Cycle Times", title = "Cycle 405 Times vs Quality") +
  theme_classic() +
  theme(plot.background = element_rect(fill = "white"))

#filter
data2_filtered_407 <- data2 %>% 
  select(quality407_L, cycleTime407_L, cycleTime407_D) %>% 
  filter(!is.na(quality407_L) & !is.na(cycleTime407_L) & !is.na(cycleTime407_D)) %>% 
  rename(quality = quality407_L, cycleTime = cycleTime407_L)

#cycle 407
plot_407 <- ggplot(data2_filtered_407, aes(x = "407", y = ifelse(cycleTime > 0, cycleTime, NA_real_), fill = quality)) +
  geom_boxplot() +
  labs(x = "Cycle", y = "Cycle Times", title = "Cycle 407 Times vs Quality") +
  theme_classic() +
  theme(plot.background = element_rect(fill = "white"))

#combine
grid.arrange(plot_402, plot_405, plot_407, ncol = 3)
plot_402
plot_405
plot_407

