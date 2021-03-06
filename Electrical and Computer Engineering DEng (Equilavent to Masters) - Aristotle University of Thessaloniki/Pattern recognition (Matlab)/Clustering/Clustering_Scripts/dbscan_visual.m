% uses 3rd party dbscan based clustering algorithm

clear all;
close all;
x = csvread('avg_sum_maxS1.csv');

%DBSCAN algorithm
%Distance threshold to consider neighbor.
E = 400;
% Minimum number of points required to form a cluster.
minPts = 4;
[C_temp, idx,C] = dbscan(x.', E, minPts); %kmedoid ready implemintation from internet
%C=x(centres,1:3); %centroids
%plot
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
%plot3(C(:,1),C(:,2), C(:,3), 'kx', 'MarkerSize', 15, 'LineWidth',3)
box on
grid on
xlabel('avg') 
ylabel('max')
zlabel('sum') 
legend('Cluster 1', 'Cluster 2' , 'Cluster 3', 'Centroids', ...
       'Location', 'NW')
title 'Cluster Assignments and Centroids: DBSCAN '
hold off;


%sihlouette
figure(2)
silhouette(x,idx, 'sqeuclidean')
s = silhouette(x,idx, 'sqeuclidean');
meansihl=mean(s) %mean sihlouette

%cohesion
coh=cohesion(x,C,idx);
meancoh=mean(coh) %mean cohesion

%seperation
sep=separation(x,idx,C);
meansep=mean(sep)

%sse
sse=sum(coh)
