# Analysis of LendingClub.com Data
# Dr. Clif Baldwin
# I downloaded data from LendingClub.com  July 25, 2019  

# #############################################

# Load any libraries you need

# Read in the data
loan <- read_csv("loans.csv")
# or 
loan <- read.csv("loans.csv")

# Look at the data


# Detect who is late?
# In other words, what observations have the word "Late" in the loan_status field?


# Define a new variable (or column) to indicate whether the loan was late (0) or not late (1)


# Calculate the correlation between late and annual income 
#   Hint: use cor()
#   Note: the parameter use="complete.obs" ignores "NA"



# The emp_length field is character with some "n/a"
# Extract just the numbers and change "n/a" to NA (hint: use parse_number())


# Compute the correlation of late and years employed



# Plot a histogram of annual income 



# Compute the summary statistics of annual income


# Explore the date columns
# You will notice they are in month-year format.
# You can convert the string month-year to a date with 
loan$col_name <-  parse_date_time(loan$col_name, "my")

# Do something with this datetime and just explore the data