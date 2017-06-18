clear all;
close all;
x = csvread('avg_sum_maxS1.csv');

%% Partition the data into two clusters, and choose the best arrangement out of five intializations. Display the final output.

clusters_no = 3;
opts = statset('Display','final');
[idx, C,sumd] = kmeans(x, clusters_no, 'Distance','sqeuclidean', 'Replicates', 5, 'Options', opts);

%% Plot the clusters and the cluster centroids

figure(1);

plot3(x(idx==1,1), x(idx==1,2), x(idx==1,3), 'r.','MarkerSize',12)
hold on
plot3(x(idx==2,1), x(idx==2,2), x(idx==2,3), 'b.','MarkerSize',12)
hold on
plot3(x(idx==3,1), x(idx==3,2), x(idx==3,3), 'g.','MarkerSize',12)
hold on
%{
plot3(x(idx==4,1), x(idx==4,2), x(idx==4,3), 'y.','MarkerSize',12)
hold on
plot3(x(idx==5,1), x(idx==5,2), x(idx==5,3), 'c.','MarkerSize',12)
hold on
plot3(x(idx==6,1), x(idx==6,2), x(idx==6,3), 'm.','MarkerSize',12)
hold on
%}
plot3(C(:,1),C(:,2), C(:,3), 'kx', 'MarkerSize', 15, 'LineWidth',3)
grid on;
box on;
xlabel('avg') 
ylabel('max')
zlabel('sum') 
legend('Cluster 1', 'Cluster 2' ,'Cluster 3','Centroids', ...
       'Location', 'NW')
title 'Cluster Assignments and Centroids: Kmeans'
hold off

%sihlouette
figure(2)
silhouette(x,idx, 'cityblock')
s = silhouette(x,idx, 'cityblock');
spc = silhouette_mean_per_cluster_( idx, clusters_no, s )
meansihl=mean(s)

%cohesion
coh=sumd;
meancoh=mean(coh) %mean cohesion

%seperation
sep=separation(x,idx,C);
meansep=mean(sep) %mean separation

%sse
sse=sum(coh)
