
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

organism = "DYSSIL"

filename = paste (organism, "/", organism, "Ohno_Self+Outgp.txt", sep = '')

file = read.table(filename, head = T, sep = "\t")

hist(file$P.self...k.)
hist(file$Multiplication.for.P1...k.)

plot(density(na.omit(file$P.self...k.)))
plot(density(na.omit(file$Multiplication.for.P1...k.)))

rm(list=ls())
