function plotplg(P,F)
% plotplg(P,F) produces the 3D graph of a mesh defined by
% its vertices P and faces (flat polygons) defined by F.
% P is a 3 by N matrix whose columns contain the coords of object vertices.
% F is a K by ... matrix whose lines (one for each face) have the following 
% semantics:
% vi = F(i,1) = number of vertices defining the i-th face (i=1:K)
% F(i,2)+1 up to F(i,1+vi)+1 = indices of the vertices (in P)
% participating in the i-th face
%
% plotplg(P,F) is compatible to READPLG that reads P, F data
% from files of PLG format
%
% See also: READPLG

% Author: A. Delopoulos
% version: 19-05-2004

for i=1:1:size(F,1)
       participating_nodes=F(i,2:1+F(i,1))+1;
       X=P(1,participating_nodes);
       Y=P(2,participating_nodes);
       Z=P(3,participating_nodes);
       patch(X,Y,Z,[1 1 1],'edgecolor',[0 0 1]);
end
