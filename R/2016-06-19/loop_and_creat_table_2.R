
##
## Clean version
##

x <- c(4000, 3100, 2200, 2110, 1111)

sum_of_counts <- c(0, 0, 0, 0, 0)
sum_of_proportions <- c(0, 0, 0, 0, 0)
results_dataframe <- data.frame(Pattern=x)

for (i in 1:5000) {
    print(paste("Working on meta-experiment ", i, sep=""))
    count_column_name <- paste("Count_", i, sep="")
    proportion_column_name <- paste("Proportion_", i, sep="")
    sample_data <- sample(x, size=37, replace=TRUE)
    table <- data.frame(table(sample_data))
    colnames(table) <- c("Pattern", count_column_name)
    table[, proportion_column_name] <- table[, count_column_name] / sample_size
    results_dataframe <- merge(results_dataframe, table, by="Pattern", all=TRUE)
    results_dataframe[is.na(results_dataframe)] <- 0
    sum_of_counts <- sum_of_counts + results_dataframe[, count_column_name]
    sum_of_proportions <- sum_of_proportions + results_dataframe[, proportion_column_name]
}

count_average <- sum_of_counts / 5000
proportion_average <- sum_of_proportions / 5000

print("Count average for 5,000 meta-experiments")
print(cbind(results_dataframe$Pattern, count_average))
print("Proportion average for 5,000 meta-experiments")
print(cbind(results_dataframe$Pattern, proportion_average))
