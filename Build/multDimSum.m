function x=multDimSum(x,dim)

%MULTDIMSUM   Performs the sum of the elements of a multidimensional array along a set of dimensions
%   X=MULTDIMSUM(X,DIM)
%   * X is an array
%   * DIM are the dimensions over which to performe the summation of the elements of the array
%   * X is the contracted array
%

for n=1:length(dim);x=sum(x,dim(n));end
