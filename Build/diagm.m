function X=diagm(X,p)

%DIAGM   Extracts the diagonals or subdiagonals of multiple square 
%matrices
%   X=DIAGM(X,{P})
%   * X is the input array
%   * {P} serves to extract upper (>0) or lower (<0) diagonals. It defaults
%   to 0 to extract the main diagonal
%   * X is the output array with the diagonals as a row vector or 
%alternatively a matrix with diagonals given by the input row vector
%

if ~exist('p','var') || isempty(p);p=0;end

N=size(X);N(end+1:3)=1;ND=length(N);

if N(1)==N(2) && N(1)~=1%Matrix to diagonal
    d=sub2indV([N(2) N(2)],repmat(single((1:N(2)-abs(p))'),[1 2]));
    if p>0;X=circshift(X,[0 -p]);elseif p<0;X=circshift(X,[p 0]);end
    X=reshape(X,[prod(N(1:2)) prod(N(3:ND))]);
    X=X(d,:);
    X=reshape(X,[1 N(1)-abs(p) N(3:ND)]);
elseif N(1)==1%Diagonal to matrix
    if p~=0
        padS=zeros(1,ND-1);padS(2)=abs(p);
        X=padarray(X,padS,0,'post');
    end
    NN=size(X,2);
    d=sub2indV([NN NN],repmat(single((1:N(2))'),[1 2]));
    Y=repmat(X,[NN ones(1,ND-1)]);
    Y(:)=0;
    Y=reshape(Y,[NN^2 N(3:ND)]);    
    X=reshape(X,[NN N(3:ND)]);
    X=dynInd(Y,d,1,dynInd(X,1:N(2),1));Y=[];
    X=reshape(X,[NN NN N(3:ND)]);
    if p>0;X=circshift(X,[0 p]);elseif p<0;X=circshift(X,[-p 0]);end
else
    error('Matrix sizes do not allow to perform the diagonal operation');
end


