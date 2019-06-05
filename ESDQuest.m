function esd=ESDQuest(C,N,tolMinEig)

%ESDQUEST  wrapper to call the Quest method described in [1] O Ledoit and 
%M Wolf, "Numerical implementation of the QuEST function," Comput Stat 
%Data Anal, 115:199-223, 2017, based on
%the implementation at www.econ.uzh.ch/dam/jcr:3a1e1268-d106-462c-af40-df1aff50d6eb/QuEST_v027.zip
%to compute a set of O empirical sample distributions (ESD) from O 
%population covariances (corresponding to the patches in the context of 
%DWI signal prediction) arranged along the third dimension with corresponding 
%atomic distributions with M equiprobable components arranged in the rows 
%or MxM covariance matrices from which to compute them 
%   ESD=ESDQUEST(C,N,{TOLMINEIG})
%   * C is the population covariance (alt atomic distribution column array)
%   * N is the number of observed samples or the aspect ratio if lower or
%   equal than 1
%   * {TOLMINEIG} is the minimum allowed eigenvalue, the covariance matrix
%   is regularized by this value to guarantee positive definiteness.
%   Defaults to 0. A small value may help to stabilize the estimates
%   * ESD is a cell array with the estimated ESDs. Each element is a 
%structure containing the following fields:
%       - ESD.GRID, the grid on which the empirical spectral distribution is
%   defined
%       - ESD.DENS, the empirical spectral distribution density
%       - ESD.THRE, the upper bound on the empirical spectral distribution
%       - ESD.GRIDD, the gradient of the grid locations
%       - ESD.APDF, the accumulated estimated pdf (for consistent moment
%       computation later on).
%

if nargin<3 || isempty(tolMinEig);tolMinEig=0;end%Setting this to a low value may help for singularities at 0

%DIAGONALIZE
NC=size(C);NC(end+1:3)=1;
assert(length(NC)<=3,'Covariance defined over %d dimensions, but only 3 are accepted',length(NC));

%DIAGONALIZE WHILE ASSURING IT IS POSITIVE DEFINITE
if NC(2)==1;isd=1;else isd=0;end
I=eye(NC(1),'like',C);
if isd;I=diagm(I);end
I=tolMinEig*I;
C=bsxfun(@plus,C,I');
I=eye(NC(1),'like',C);
if ~isd;eigv=eigm(C);else eigv=C;end

if N<=1;N=round(NC(1)/N);end%Second input is aspect ratio instead of number of samples
Beta=NC(1)/N;
eigv=gather(double(abs(eigv)));

esd=cell(1,NC(3));
w=ones(NC(1),1)/NC(1);

if NC(3)>=8
    parfor o=1:NC(3);esd{o}=callQuest(eigv(:,1,o),w,N,Beta);end
else
    for o=1:NC(3);esd{o}=callQuest(eigv(:,1,o),w,N,Beta);end
end

end

function esdo=callQuest(tau,weight,N,Beta)
    def.tau=tau;
    def.weight=weight;
    def.n=N;
    def.p=length(def.tau);
    def.c=Beta;   
    if any(def.tau(:)>1e-6)
        [den,~,~,sup]=denfun03(def); 
        den.x=cat(1,sup.endpoint(:),den.x);
        den.f=cat(1,zeros(numel(sup.endpoint),1),den.f);
        [den.x,idx]=sort(den.x);
        den.f=den.f(idx);
        esdo.grid=single(den.x);esdo.dens=single(den.f);esdo.thre=single(max(sup.endpoint(:)));
        esdo.gridd=gradient(esdo.grid);
        esdo.apdf=sum(esdo.dens.*esdo.gridd);
    else
        esdo=[];
    end
end
