%MIXANDMIX_EXP04 script performs the experiment included in Fig. 3c of the 
%manuscript "Numerical techniques for the computation of sample spectral 
%distributions of population mixtures", L Cordero-Grande, unpublished, 
%2018.

clearvars
addpath(genpath('.'));%Add code
styleFigRoutine;

M=100;
Beta=0.5;

N=round(M/Beta);
C=ones(M,1);
M=size(C,1);
Beta=M/N;
    
%SPECTRODE    
tolSpe=1e-6;
esd=ESDSpectrode(C,N,tolSpe);
    
%QUEST
esdAux=ESDQuest(C,N);
esd{2}=esdAux{1};
    
%OURS STANDARD
tolFpa=1e-5;
NL=3;
esd{3}=ESDMixAndMix(C,N,tolFpa,NL);
    
%MP
esdRef=ESDMarcenkoPastur(Beta,M*M);
    
meth={'SPECTRODE','QuEST','MIXANDMIX','f(x)'};
err=zeros(3,M*M);
for m=1:3
    fprintf('Method: %s. Number of grid points: %d\n',meth{m},length(esd{m}.grid));
    dens=interp1(esd{m}.grid,esd{m}.dens,esdRef.grid,'linear',0);   
    err(m,:)=abs(dens-esdRef.dens);
end

err=max(err,10^(-10));
esdRef.dens=max(esdRef.dens,1e-10);

%Fig 3c
figure
pM=[];
for n=1:3
    N=length(esdRef.grid);sub=ceil(N/10);
    semilogy(esdRef.grid,err(n,:),'Color',Colors(n,:));hold on;
    h{n}=semilogy(esdRef.grid(1:sub:end),err(n,1:sub:end),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
    semilogy(esdRef.grid(pM),err(n,pM),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
end
n=4;
N=length(esdRef.grid);sub=ceil(N/10);
semilogy(esdRef.grid,esdRef.dens,'Color',Colors(n,:));
h{n}=semilogy(esdRef.grid(1:sub:end),esdRef.dens(1:sub:end),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
semilogy(esdRef.grid(pM),esdRef.dens(pM),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
grid on
ax=gca;ax.FontSize=FontSizeC;
labelFig('$x$','$\Delta f(x)$','\textbf{c) Accuracy (MP)}',FontSizeA);
hh=legend([h{1} h{2} h{3} h{4}],meth,'FontSize',FontSizeB,'Interpreter','latex');
pos=get(hh,'Position');
pos(1)=pos(1)-0.154;
pos(2)=pos(2)-0.036;
set(hh,'Position',pos);
