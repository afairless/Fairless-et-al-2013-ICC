# Andrew Fairless, August 2011
# modified April 2015 for posting onto Github
# This script calculates interrater reliabilities for Table 2 of Fairless et al 2013
# Fairless et al 2013, doi: 10.1016/j.bbr.2012.08.051, PMID: 22982070, PMCID: PMC3554266
# The interrater reliabilities are calculated for each pair of raters.  There are 3 raters.
# Each interrater reliability is calculated as a Pearson's r and as an ICC(A,1)

install.packages("irr", dependencies = TRUE) # install package if not already installed
library(irr)     	                         # library includes intraclass correlation coefficient (ICC) functions

# The fictional data in "altereddata.txt" were modified from the original 
# empirical data used in Fairless et al 2013.
# I am using fictional data instead of the original data because I do not have 
# permission of my co-authors to release the data into the public domain.  
# Each row is a separate mouse/scoring period; 20 mice socially interacted in 10 pairs.
# Each column is a different social behavior or rater; 3 raters scored 16 social behaviors.
# NOTE:  Because these data are fictional, several important characteristics of
# these data may be different from those of the original data (e.g., interrater
# correlations are probably lower, behaviors may not sum properly)
data = read.table("altereddata.txt", header = TRUE)	

# Each of the 3 raters scored 16 social behaviors contained in 16 columns.
# The indices below identify the leftmost column for each rater's block of 16 columns.
rater1col1 = 1	
rater2col1 = 17	
rater3col1 = 33	

varnum = 16	     # the number of columns/social behaviors per rater

# sets up each combination of rater pairs
ratercombo = combn(c(rater1col1, rater2col1, rater3col1), m = 2)      


sink(file = "output.txt")

# The loop iterates over each combination of rater pairs
for(iter2 in 1:dim(ratercombo)[2]) {
     startcol1 = ratercombo[1, iter2]	
     startcol2 = ratercombo[2, iter2]     
     
     # The loop iterates from the leftmost column for each rater across each column/behavior
     for(iter in 1:varnum) {	
          cat("\n")	
     
          # print names of the two variables that are correlated
          print(colnames(data[startcol1 - 1 + iter]))	
          print(colnames(data[startcol2 - 1 + iter]))	
     
          print(cor(data[startcol1 - 1 + iter], data[startcol2 - 1 + iter])[[1]])	# Pearson's r
          print(icc(cbind(data[startcol1 - 1 + iter], data[startcol2 - 1 + iter]), 
                    model = 't', type = 'a', unit = 's')[[7]][1])                    # ICC(A,1)
          # to see full ICC results, use the line of code below
          # print(icc(cbind(data[startcol1 - 1 + iter], data[startcol2 - 1 + iter]), model = 't', type = 'a', unit = 's'))     
     }	
}

sink(file = NULL)
