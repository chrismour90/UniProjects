function [ spc ] = silhouette_mean_per_cluster_( idx, clusters_no, s )
%SILHOUETTE_MEAN_PER_CLUSTER_ Find each cluster's silhouette
%@arg idx = vector with cluster for each element
%@clusters_no = number of used clusters
%@arg s = silhouette for each element
%@return spc = silhouette for each of the clusters

size = length(idx);
sum = zeros(clusters_no, 1);
sums = zeros(clusters_no, 1);
spc = zeros(clusters_no, 1);
for i = 1:size
    sum(idx(i)) = sum(idx(i)) + 1;
    sums(idx(i)) = sums(idx(i)) + s(i);
end

for i = 1:length(sum)
    spc(i) = sums(i) / sum(i);
end


end

