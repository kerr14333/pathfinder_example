## -----------------------------------------------------------------------------
####################
## load libraries
####################
suppressMessages(  library(cmdstanr) ) 
suppressMessages(  library(dplyr) )
suppressMessages(  library(jsonlite) )

#set cmdstan path
# SET THIS TO YOUR VERSION OF PATHFINDER!!
set_cmdstan_path("/ext/work/cmdstan/laplace_testing/cmdstan")

#read in our dataset
stan_data <- readRDS("stan_data.rds")  


## ----message=F----------------------------------------------------------------

####### Compile with parallel

#removing executable to force recompile (had trouble with force_recompile)
temp <- file.remove("fh")

### compile stan script
## note that I use capture.output to make the markdown cleaner
temp <- capture.output( mod1     <- cmdstanr::cmdstan_model("fh.stan", cpp_options=list(stan_threads=TRUE)) )

fileConn<-file("output1.txt")
output <- capture.output({
fit1 = mod1$pathfinder(algorithm = "multi", 
                       data = stan_data,
			        refresh = 1, 
                       threads=12, 
                       num_threads = 12, 
                       num_paths = 12) 
}) #end capture output
cat(output, file=fileConn , sep="\n")
close(fileConn)

draws_df1 <- fit1$draws("y_rep",format="df")



## ----message=F----------------------------------------------------------------

head(draws_df1)

draw_dist1 <-  draws_df1 %>% select( starts_with("y_rep" )) %>% distinct()
n_dist1 <- draw_dist1 %>% nrow() 
                        


## ----message=F----------------------------------------------------------------
#removing executable to force recompile (had trouble with force_recompile)
temp <- file.remove("fh")

### compile stan script
## note that I use capture.output to make the markdown cleaner
temp <- capture.output( mod2     <- cmdstanr::cmdstan_model("fh.stan"))

fileConn<-file("output2.txt")
output <- capture.output({

fit2 = mod2$pathfinder(algorithm = "multi", 
                       data = stan_data,
			        refresh = 1, 
                       num_paths = 12) 
})
cat(output, file=fileConn, sep="\n" )
close(fileConn)

draws_df2 <- fit2$draws("y_rep",format="df")


## -----------------------------------------------------------------------------

head(draws_df2)



## -----------------------------------------------------------------------------

draw_dist2 <-  draws_df2 %>% select( starts_with("y_rep" )) %>% distinct()
n_dist2 <- draw_dist2 %>% nrow() 


