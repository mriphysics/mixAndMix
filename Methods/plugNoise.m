function x=plugNoise(x)

% PLUGNOISE plugs complex circularly symmetric AWGN noise samples in an 
%array
%   X=PLUGNOISE(X) 
%   * X is the input array
%   * X is the noise array with same dimensions as the input array
%

gpu=isa(x,'gpuArray');
N=size(x);
x=single(randn(N))+1i*single(randn(N));
if gpu;x=gpuArray(x);end
