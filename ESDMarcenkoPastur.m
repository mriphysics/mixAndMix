function esd=ESDMarcenkoPastur(Beta,N)

%ESDMARCENKOPASTUR  computes the expression for the Marcenko-Pastur (MP) distribution
%   ESD=ESDMARCENKOPASTUR(BETA,{N})
%   * BETA is the aspect ratio assumed to be between 0 and 1
%   equal than 1
%   * {N} is the number of points where to compute the Marcenko-Pastur distribution. 
%   It defaults to 256
%   * ESD is a cell array with the estimated ESD. It contains the following fields
%       - ESD.GRID, the grid on which the MP distribution is computed
%       - ESD.DENS, the empirical spectral distribution density
%

if nargin<2;N=256;end

minV=(1-sqrt(Beta)).^2;
maxV=(1+sqrt(Beta)).^2;

if numel(N)==1;esd.grid=linspace(minV,maxV,N);else esd.grid=N;end
esd.dens=marcenkoPastur(esd.grid,Beta);
esd.gridd=gradient(esd.grid);
esd.apdf=sum(esd.dens.*esd.gridd);


