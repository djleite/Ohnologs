wgd <- 500
tips <- c('CARROT', 'TACGIG')
div_times <- c( 0 ,63,
		63,0
)

mx <- matrix(div_times, nrow = length(tips), dimnames = list(tips, tips))

## Calculation of the weights
#det(mx)
m = wgd - mx 
m = m * m
m = m / (wgd * wgd)

inv = solve(m)

final = inv %*% rep(1, dim(m)[1])

#sum(final)
final <- as.data.frame(final)

df <- data.frame(matrix(ncol = 4, nrow = length(tips)))
x <- c("species_name","sp_id","weight","weight_2")
colnames(df) <- x

df$species_name <- tips
df$sp_id <- tips
df$weight <- rep(0.25, length(tips))
df$weight_2 <- final$V1

print(df)

write.table(df,"spiders_weights.txt", sep="\t",row.names=FALSE, quote = FALSE)


