# Daniel W. Anner
# Linear Regression 
# DSSA 5104 Assignment

# PseudoCode
# Read in the data
# Divide data into training and test data
# Train the model using the dataset:
#  Create X Matrix [1, xi1, xi2,...,xik] from all rows i of training data and for k variables
#  Create Y Matrix (vector)
# Solve for the β vector, 
# Make predictions using the test dataset:
#  Create X Matrix [1, xi1, xi2,...,xik] from all rows i of test data and for k variables
#  Compute Ŷ = βX
# Test the Model:
#  Compute the Sum of Squared Errors RSS 
#  Compute the Total Sum of Squares TSS 
#  Compute R2 = 1 – RSS / TSS

setwd('C:\\Users\\danie\\_Source\\Stockton-DSSA\\DSSA-5201_Machine_Learning_Fundamentals\\LinearRegression')
# Get the Data
df <- read.csv("", header = TRUE)