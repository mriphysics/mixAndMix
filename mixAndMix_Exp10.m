%MIXANDMIX_EXP10 script performs the experiment included in Fig. 4f of the 
%manuscript "Numerical techniques for the computation of sample spectral 
%distributions of population mixtures", L Cordero-Grande, unpublished, 
%2018.

clearvars
addpath(genpath('.'));%Add code
styleFigRoutine;

M=100;
Beta=0.5;

eig=100;
w=0.01;

N=round(M/Beta);
C=ones(M,1);
C(M*w+1:M)=eig;
M=size(C,1);
Beta=M/N;
    
%SPECTRODE    
tolSpe=1e-3;
esd=ESDSpectrode(C,N,tolSpe);
    
%QUEST
esdAux=ESDQuest(C,N);
esd{2}=esdAux{1};
    
%OURS STANDARD
tolFpa=1e-4;
NL=3;
esd{3}=ESDMixAndMix(C,N,tolFpa,NL);
    
%TWO-DELTAS
esdRef=ESDTwoDeltas(Beta,M*M,1-w,eig);
    
meth={'SPECTRODE','QUEST','MIXANDMIX','f(x)'};
err=zeros(3,M*M);
for m=1:3
    fprintf('Method: %s. Number of grid points: %d\n',meth{m},length(esd{m}.grid));
    dens=interp1(esd{m}.grid,esd{m}.dens,esdRef.grid,'linear',0);   
    err(m,:)=abs(dens-esdRef.dens);
end

err=max(err,1e-10);
esdRef.dens=max(esdRef.dens,1e-10);

%Fig 4f
figure
pM=[1 15 25 1097];
for n=1:3
    N=length(esdRef.grid);sub=ceil(N/10);
    loglog(esdRef.grid,err(n,:),'Color',Colors(n,:));hold on;
    h{n}=loglog(esdRef.grid(pM),err(n,pM),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
end
n=4;
N=length(esdRef.grid);sub=ceil(N/10);
loglog(esdRef.grid,esdRef.dens,'Color',Colors(n,:));
h{n}=loglog(esdRef.grid(pM),esdRef.dens(pM),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
grid on
xlim([-inf 5e3])
ax=gca;ax.FontSize=FontSizeC;
labelFig('$x$','$\Delta f(x)$','\textbf{f) Accuracy ($\mathbf{\delta\delta}$ RS)}',FontSizeA);
hh=legend([h{1} h{2} h{3} h{4}],meth,'FontSize',FontSizeB,'Interpreter','latex');
pos=get(hh,'Position');
pos(1)=pos(1)+0.115;
pos(2)=pos(2)+0.045;
set(hh,'Position',pos);
