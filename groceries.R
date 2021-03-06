library(arules)
groceries<-read.transactions("C:/Users/abc/Desktop/Data science/Dataset/Association Rule/groceries.csv",format="basket")#head=TRUE does not display the transaction items in the data
class(groceries)
inspect(groceries[1:10]) #To view the transactions, use the inspect() function


size(head(groceries)) # number of items in each observation
LIST(head(groceries, 3)) # convert 'transactions' to a list, note the LIST in CAPS


options(max.print=999999) #without this function i got a warning as  [ reached getOption("max.print") -- omitted 29 rows ] where only 21 rows output was shown and my data set had more rows than it


frequentItems <- eclat (groceries, parameter = list(supp = 0.002, maxlen = 5)) # calculates support for frequent items
inspect(frequentItems)
#eclat() takes in a transactions object and gives the most frequent items in the data 
#maxlen defines the maximum number of items in each itemset of frequent items


itemFrequencyPlot(groceries, topN=10, type="absolute", main="Item Frequency")  #plot frequent items,itemFrequencyPlot can be applicable only for transaction data 


###RULE 1

rules <- apriori (groceries, parameter = list(supp = 0.001, conf = 0.5)) # Min Support as 0.001, confidence as 0.8.
rules_conf <- sort (rules, by="confidence", decreasing=TRUE) # 'high-confidence' rules.
inspect(head(rules_conf)) # show the support, lift and confidence for all rules
#The rules with confidence of 1 imply that, whenever the LHS item was purchased,the RHS item was also purchased 100% of the time.

rules_lift <- sort (rules, by="lift", decreasing=TRUE) # 'high-lift' rules.
inspect(head(rules_lift)) # show the support, lift and confidence for all rules
#A rule with a lift of 182 imply that, the items in LHS and RHS are 182 times more likely to be purchased together compared to the purchases when they are assumed to be unrelated.

#To get 'strong' rules,we increase the value of 'conf' parameter.
#To get 'longer' rules, increase 'maxlen'.

subsetRules <- which(colSums(is.subset(rules, rules)) > 1) # get subset rules in vector
length(subsetRules)  
rules <- rules[-subsetRules] # remove subset rules. 

###RULE2

rules <- apriori (data=groceries, parameter=list (supp=0.001,conf = 0.08), appearance = list (default="lhs",rhs="bags"), control = list (verbose=F)) # get rules that lead to buying 'bags'
rules_conf <- sort (rules, by="confidence", decreasing=TRUE) # 'high-confidence' rules.
inspect(head(rules_conf))
#we found out what customers had purchased before buying 'bags'. This will help us understand the patterns that led to the purchase of 'bags'

###RULE3

rules <- apriori (data=groceries, parameter=list (supp=0.001,conf = 0.08), appearance = list(default="rhs",lhs="vegetables"), control = list (verbose=F)) # those who bought 'vegetables' also bought..
rules_conf <- sort (rules, by="confidence", decreasing=TRUE) # 'high-confidence' rules.
inspect(head(rules_conf))

#we will check for beer 

rules <- apriori (data=groceries, parameter=list (supp=0.001,conf = 0.08), appearance = list(default="rhs",lhs="beer"), control = list (verbose=F)) # those who bought 'beer' also bought..
rules_conf <- sort (rules, by="confidence", decreasing=TRUE) # 'high-confidence' rules.
inspect(head(rules_conf))

######Visualization######

library(arulesViz)
plot(rules,method = "scatterplot", jitter=0 )
plot(rules,method = "grouped")
plot(rules,method="paracoord",control=list(reorder=TRUE))
plot(rules,method = "graph")
#plot(rules,method = "mosaic")  #this plot dont work for all rules together it can visualize one rule at one time
plot(rules,method="two-key plot", jitter=0)
top4rules <- head(rules, n = 10, by = "confidence")
plot(top4rules, method = "graph",  engine = "htmlwidget") #an interactive plot


###Trying different values of support and confidence 

rules1 <- apriori (groceries, parameter = list(supp = 0.05, conf = 0.9))
rules_conf1 <- sort (rules1, by="confidence", decreasing=TRUE) # 'high-confidence' rules.
inspect(head(rules_conf1))

rules1 <- apriori (groceries, parameter = list(supp = 0.01, conf = 1))
rules_conf1 <- sort (rules1, by="confidence", decreasing=TRUE) # 'high-confidence' rules.
inspect(head(rules_conf1))

plot(rules1,method = "scatterplot", jitter=0 )
plot(rules1,method = "grouped")
plot(rules1,method="paracoord",control=list(reorder=TRUE))

####Changing the minimum length in apriori algorithm

rules2 <- apriori (data=groceries, parameter=list (supp=0.001,conf = 0.15,minlen=2,maxlen = 15), appearance = list(default="rhs",lhs="canned"), control = list (verbose=F)) # those who bought 'vegetables' also bought..
rules_conf2 <- sort (rules2, by="confidence", decreasing=TRUE) # 'high-confidence' rules.
inspect(head(rules_conf2))

plot(rules2,method = "scatterplot", jitter=0 )
plot(rules2,method="paracoord",control=list(reorder=TRUE))


