function Coh = cohesion(dataset,Centroids,Idx)
%@arg dataset : n x dimensions Matrix
%@arg Centroids : numclusters x dimensions
%@arg Idx : Cluster Index Vector 
%@return Coh : Cohesion coef for each cluster (numclusters x 1)


[num_instances,num_attrs] = size(dataset);
num_clusters = length( Centroids(:,1) );

Coh = zeros(num_clusters,1);

for i=1:num_instances
    
    cluster_id = Idx(i) ;
    if cluster_id ~=0
        Coh( cluster_id ) = Coh( cluster_id ) + sum( (dataset(i,:) - Centroids(cluster_id,:)).^2 );
    end
    
end;

return
    