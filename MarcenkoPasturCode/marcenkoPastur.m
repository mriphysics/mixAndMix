function y=marcenkoPastur(x,beta)

%MARCENKOPASTUR returns the Marcenko-Pastur distribution of an array
%   Y=MARCENKOPASTUR(X,{BETA})
%   * X is the array where to compute the distribution
%   * {BETA} is the aspect ratio, it is assumed to be lower or equal to 1. 
%   Defaults to 1.
%   * Y is the corresponding Marcenko-Pastur distribution
%

assert(beta<=1,'For consistency with the rest of the suite, the aspect ratio should be lower than one and it is %.2f',beta);

betapl=(1+sqrt(beta))^2;
betami=(1-sqrt(beta))^2;

y=sqrt(abs((betapl-x).*(x-betami)))./((2*pi*beta)*x);
y(x>=betapl | x<=betami)=0;
