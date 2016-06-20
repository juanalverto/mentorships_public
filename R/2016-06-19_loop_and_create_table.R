##
## 2016/06/19
##
## Problem description:
##
## I have an assignment that requires me to run 2 simulations
## I need to loop them with a for loop and then create a table
## for each simulation. Can provide my assignment details!!
##

##
## After talking with the person and understanding their specific
## problem. This is the code that was useful to them:
##

## Bee's holes possible results
x <- c(4000, 3100, 2200, 2110, 1111)

## Parameters
sample_size <- 37
number_of_iterations <- 5000

## Create the dataframe with one column (`pattern`)
results_dataframe <- data.frame(Pattern=x)

## Start iterating
for (i in 1:number_of_iterations) {

    ## Print information
    print(paste("Working on meta-experiment ", i, sep=""))

    ## Create a new sample each time
    ## (it contains 37 values)
    sample_data <- sample(x, size=sample_size, replace=TRUE)

    ## Get the frequencies table
    table <- data.frame(table(sample_data))

    ## Get `Count_i` and `Proportion_i` column names
    count_column_name <- paste("Count_", i, sep="")
    proportion_column_name <- paste("Proportion_", i, sep="")

    ## Use the column names in the document
    colnames(table) <- c("Pattern", count_column_name)

    ## Create the proportion column
    table[, proportion_column_name] <- table[, count_column_name] / sample_size

    ## Add results columns to the `results_dataframe` (using outer join)
    results_dataframe <- merge(results_dataframe, table, by="Pattern", all=TRUE)
}

## At this point, `results_dataframe` contains number of pair columns
## (Count, Proportion) equal to the `number_of_iteraions`. We need to
## provide statistics for this (I'll just do the mean (average) here).
## This should be done inside the previous foor loop for efficiency,
## but I'm putting it separate in case you want to customize it.

## Convert all NA's to zeros
results_dataframe[is.na(results_dataframe)] <- 0

# Initial placeholders for accumulated sums
sum_of_counts <- c(0, 0, 0, 0, 0)
sum_of_proportions <- c(0, 0, 0, 0, 0)

for (i in 1:number_of_iterations) {

    # This iteration's column names
    count_column_name <- paste("Count_", i, sep="")
    proportion_column_name <- paste("Proportion_", i, sep="")

    # Accumulated sum (used to compute average)
    sum_of_counts <- sum_of_counts + results_dataframe[, count_column_name]
    sum_of_proportions <- sum_of_proportions + results_dataframe[, proportion_column_name]
}

## Divide by the `number_of_iterations` to get the mean (average)
count_average <- sum_of_counts / number_of_iterations
proportion_average <- sum_of_proportions / number_of_iterations

print(paste("Count average for ", number_of_iterations, " meta-experiments"))
print(cbind(results_dataframe$Pattern, count_average))

print(paste("Proportion average for ", number_of_iterations, " meta-experiments"))
print(cbind(results_dataframe$Pattern, proportion_average))

## The full results table with the "meta-experiments" is in
## `results_dataframe`. Be careful because it can be very big.
## print(results_dataframe)
