function [P, F] = readplg(filename)
%function [P, F] = readplg(filename)
%This function reads the PLG file given in filename and returns:
%P: 3xn matrix with the object vertices
%F: mxl matrix containing the facet descriptions. For each row of F, the 
%first entry NUM_VERT=F(i,1) contains the number of vertices for the facet and 
%the rest NUM_VERT entries (F(i,2:NUM_VERT+1)), the 0-based indices of the 
%vertices in the point matrix P.
%
%NOTES: this function ignores PLG surface descriptors
%       the indices are 0-based, while MATLAB arrays are 1-based
%
%MUG@IPL@AUTh@GR
%
%PLG description
% A PLG file basically has three parts: a header line, a list
% of vertices and a list of facets.
% 
% The header line has the object name, the number of vertices,
% and the number of facets; for example:
% 
%      kitchen_table 100 35
% 
% which would mean that the object "kitchen_table" has 100 vertices
% and 35 facets.
% 
% Following this line are the vertices, one x,y,z triplet per
% line (each value is a floating-point number, and they're
% separated by spaces).  For example:
% 
%      18027 23025 98703
% 
% This is followed by the facet information, one line per
% facet; each of these lines is of the form
% 
%      surfacedesc n v1 v2 v3 ...
% 
% The surfacedesc is described below.  The n is the number of
% vertices in the facet.  The v1, v2, v3 and so on are indices into
% the array of vertices; the vertices are listed in a counter-
% clockwise order as seen from the "front" (i.e. visible side) of
% the facet.  Note that the vertices are counted "origin zero",
% i.e. the first vertex is vertex number 0, not vertex number 1.
% 
% For example:
% 
%      0x8002 4 8 27 5 12
% 
% would mean a four-sided facet bounded by vertices 8, 27, 5 and
% 12.  This facet has a surface descriptor of 0x8002.
% 
% 
% The PLG format supports comments.  Anything after a # should
% be ignored by any program that parses PLG files.  In addition,
% lines beginning with a '*' should be ignored.
%
%(taken from http://local.wasp.uwa.edu.au/~pbourke/dataformats/plg/)
%


fid=fopen(filename,'r');

objname=fscanf(fid,'%s',1);

N=fscanf(fid,'%d',1);

K=fscanf(fid,'%d',1);

P=zeros(3,N);

for i=1:N
    for j=1:3
        P(j,i)=fscanf(fid,'%f',1);
    end
end

position = ftell(fid);

vernums=zeros(K,1);

for i=1:K
    id=fscanf(fid,'%x',1);
    vernums(i)=fscanf(fid,'%d',1);
    fgetl(fid);
end

Fcols=max(vernums)+1;
F=zeros(K,Fcols);

fseek(fid,position,'bof');

for i=1:K
    id=fscanf(fid,'%x',1);
    F(i,1)=fscanf(fid,'%d',1);
    for j=1:F(i,1)
        F(i,j+1)=fscanf(fid,'%d',1);
    end
end

fclose(fid);