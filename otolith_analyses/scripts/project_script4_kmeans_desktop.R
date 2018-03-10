
install.packages("vegan")
library("vegan")



edge.mrel_dist <- dist(odata_edge, method = "euclidean")
head(edge.mrel_dist)
core.mrel_dist <- dist(odata_core, method = "euclidean")


edge_kmeans <- cascadeKM(odata_edge, inf.gr=2, sup.gr=7)
plot(edge_kmeans)


edge_k2 <- kmeans(x=odata_edge, centers=2, nstart=100, iter.max = 1000)

edge_k2$cluster
str(edge_k2)
as.dendrogram(edge_k2)
