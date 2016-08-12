##
## 2016/06/26
##
## Problem description:
##
## I want to apply a function to each column in a dataframe
## that is created from different data files and then put
## all the reduced data in a single dataframe.
##

##
## After talking with the person and understanding their specific
## problem. This is the code that was useful to them:
##

setwd("~/Downloads/")
results <- data.frame()
data_files <- list.files(pattern="*.csv")

for (file in data_files) {
    print(paste("Working on: ", file, sep=""))
    data <- read.csv(file=file)

    ## Best way most of the time
    aggregated_data <- apply(data, 2, mean)

    ## Easy way
    ## aggregated_data <- colMeans(data)

    ## For functions that don't behave nicely
    ## aggregated_data <- data.frame(matrix(unlist(apply(data, 2, mean)), nrow=1))

    results <- rbind(results, aggregated_data)
}
colnames(results) <- colnames(data)
print(results)
