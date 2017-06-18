function S = separation(dataset, Idx, Centroids)

[num_instances,num_attrs] = size(dataset);
num_clusters = length( unique(Idx) );
S = zeros(num_clusters,1);   
Clusters = zeros(num_clusters,1);

sumof = 0;

for i=1:num_clusters
    sumof = sumof + Centroids(i,:);
end;

m = sumof / num_clusters;

for i=1:num_instances
    cluster_id = Idx(i);
    Clusters(cluster_id) = Clusters(cluster_id) + 1;
end;

for i=1:num_clusters
%     x = (m - Centroids(i,:) ) .^2 ;
%     y = sum(x);
    S(i) =  Clusters(i) * sum( ( m - Centroids(i,:) ).^2 ); 
end;

end