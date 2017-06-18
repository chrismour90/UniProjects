function [Centroids,Clusters] = get_centroids( dataset,Idx )
%@arg dataset : n x dimensions Matrix
%@arg Idx : Cluster Index Vector 
%@return Centroids (numclusters x numattr  Matrix)
%@return Clusters : number of points assigned for each cluster (numclusters x 1 Vector) 

[num_instances,num_attrs] = size(dataset);
num_clusters = length( unique(Idx) );
Sumof = zeros (num_clusters,num_attrs);
Centroids = zeros( num_clusters, num_attrs );
Clusters = zeros(num_clusters,1);

for i=1:num_instances  
    cluster_id = Idx(i);
    Sumof(cluster_id,:) = Sumof(cluster_id,:) + dataset(i,:);
    Clusters(cluster_id) = Clusters(cluster_id) + 1;
end;

for i=1:num_clusters
     Centroids(i,:) = Sumof(i,:) / Clusters(i);
end;

return