clear all;
close all;
x = csvread('avg_sum_maxS1.csv');
Result=[];

%---options---%
% 1 : kmeans
% 2 : hierarchical
% 3 : k-medoids
% 4 : all
%-------------%

option = 4;

%% kmeans 
if (option == 1)

for num_of_cluster = 1:10  
    centroid = kmeans(x,num_of_cluster,'distance','sqeuclid');  
    s = silhouette(x,centroid,'sqeuclid');  
    Result = [ Result; num_of_cluster mean(s)];  
end  

plot( Result(:,1),Result(:,2),'r*-.');

end

%% hierarchical

if (option == 2)

for num_of_cluster = 1:10  
    y = pdist(x);
    z = linkage(y);
    T = cluster(z,'maxclust',num_of_cluster);
    s = silhouette(x,T,'sqeuclid');  
    Result = [ Result; num_of_cluster mean(s)];  
end  

plot( Result(:,1),Result(:,2),'r*-.');

end

%% kmedoids

if (option == 3)
    
    for num_of_cluster = 1:10  

      [idx, energy,index] = kmedoids(x.', num_of_cluster); %kmedoid ready implemintation from internet
        s = silhouette(x,idx,'sqeuclid');
            Result = [ Result; num_of_cluster mean(s)];  

    
        
    end
    plot( Result(:,1),Result(:,2),'r*-.');

end

%% all
if (option == 4)
    
    
    
   for num_of_cluster = 1:10  
    
    centroid = kmeans(x,num_of_cluster,'distance','sqeuclid');  
    s1 = silhouette(x,centroid,'sqeuclid');  
   

    y = pdist(x);
    z = linkage(y);
    T = cluster(z,'maxclust',num_of_cluster);
    s2 = silhouette(x,T,'sqeuclid');  
    
    
    [idx, energy,index] = kmedoids(x.', num_of_cluster); 
    s3 = silhouette(x,idx,'sqeuclid');
    
    Result = [ Result; num_of_cluster mean(s1) mean(s2) mean(s3)];  


   end   

   
       plot( Result(:,1),Result(:,2),'r*-.');
       hold on
       plot( Result(:,1),Result(:,3),'b*-.');
       hold on
       plot( Result(:,1),Result(:,4),'g*-.');
       grid on
        
       xlabel('number of clusters') 
       ylabel('mean of silhouette')
       legend('kmeans', 'hierarchical' ,'kmedoids')
title 'Mean of Silhouette for clustering algorithms'
hold off

end