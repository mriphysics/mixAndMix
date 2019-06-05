function plotObjective(eigv,Beta,gridz,range,N,st,tit)

%PLOTOBJECTIVE  plots the squared residuals of the objective function driven
%by the fixed point equation
%   PLOTOBJECTIVE(EIGV,BETA,GRIDX,{RANGE},{N})
%   * EIGV is an array containing the eigenvalues of the population (assumed 
%   equally probable), it should be a column vector
%   * BETA is the aspect ratio
%   * GRIDZ is the point in the complex domain for which we are interested to
%   observe the residuals
%   * {RANGE} is the area on which we are interested to observe the residuals
%   * {N} is the number of points where to compute the residuals
%   * {ST} indicates whether to use the figure style from the paper
%   * {TIT} names with a title
%

if nargin<4 || isempty(range);range=[-1 1;-1 1];end
if nargin<5 || isempty(N);N=256;end
if nargin<6 || isempty(st);st=0;end
if nargin<7;tit=[];end

if st;styleFigRoutine;end

if numel(N)==1;N=N*ones(1,2);end
eigv=permute(eigv,[2 3 1]);

vgridr=linspace(range(1,1),range(1,2),N(1));
vgridi=1i*linspace(range(2,1),range(2,2),N(2));
[vgrid1,vgrid2]=ndgrid(vgridr,vgridi);
vgridz=vgrid1+vgrid2;
f1=vgridz-mean(bsxfun(@rdivide,eigv,bsxfun(@minus,bsxfun(@rdivide,eigv,1+Beta*vgridz),gridz)),3);

r1=log10(f1.*conj(f1));
v=-10:0.5:10;

if ~st
    figure
    grid on
    surface(vgrid1,imag(vgrid2),r1);
    hold on
    contour3(vgrid1,imag(vgrid2),r1,v,'k');    
    xlabel('$\Re\{e\}$','Interpreter','latex')
    ylabel('$\Im\{e\}$','Interpreter','latex')
    if ~isempty(tit);title(tit,'Interpreter','latex');end
    colormap('default') 
    shading interp
    caxis([-4.5 5.5])
    hcb=colorbar;
    title(hcb,'$\log_{10}(|h(e)|^2)$','Interpreter','latex')    
else
    figure
    axis square
    surface(vgrid1,imag(vgrid2),r1);
    hold on
    contour3(vgrid1,imag(vgrid2),r1,v,'k');
    ax=gca;ax.FontSize=FontSizeC;
    labelFig('$\Re\{e\}$','$\Im\{e\}$',[],FontSizeA);
    if ~isempty(tit);title({'',tit},'Interpreter','latex','FontSize',FontSizeA);end
    colormap('inferno') 
    shading interp
    caxis([-4.5 5.5])
    hcb=colorbar;    
    hcb.FontSize=FontSizeC;
    title(hcb,' $\log_{10}(|h(e)|^2)$','Interpreter','latex','FontSize',FontSizeA)   
end
view(2)
