%MIXANDMIX_EXP09 script performs the experiment included in Figs. 4d and 4e
%of the manuscript "Numerical techniques for the computation of sample 
%spectral distributions of population mixtures", L Cordero-Grande, 
%unpublished, 2018.

clearvars
addpath(genpath('.'));%Add code
quick=0;%Set to 1 for quick inspection of results
styleFigRoutine;

M=100;
if quick;BetaV=0.05:0.15:0.95;else BetaV=0.025:0.05:0.975;end
NB=length(BetaV);

eig=100;
w=0.01;

tim=zeros(NB,3);
err=zeros(NB,3);
for n=1:NB
    Beta=BetaV(n);
    N=round(M/Beta);
    C=ones(M,1);
    C(M*w+1:M)=eig;
    M=size(C,1);
    Beta=M/N;
    
    %SPECTRODE    
    tolSpe=1e-3;
    esd=ESDSpectrode(C,N,tolSpe);
    tim(n,1)=timeit(@()ESDSpectrode(C,N,tolSpe));
    
    %QUEST
    esdAux=ESDQuest(C,N);
    tim(n,2)=timeit(@()ESDQuest(C,N));
    esd{2}=esdAux{1};
    
    %OURS STANDARD
    tolFpa=1e-4;
    NL=3;
    esd{3}=ESDMixAndMix(C,N,tolFpa,NL);
    tim(n,3)=timeit(@()ESDMixAndMix(C,N,tolFpa,NL));
    
    %TWO-DELTAS
    esdRef=ESDTwoDeltas(Beta,M*M,1-w,eig);
    
    for m=1:3
        dens=interp1(esd{m}.grid,esd{m}.dens,esdRef.grid,'linear',0);
        err(n,m)=mean(abs(dens-esdRef.dens));
    end
end

meth={'SPECTRODE','QUEST','MIXANDMIX'};

%Fig 4d
figure
for n=1:3
    semilogy(BetaV',err(:,n),'Color',Colors(n,:));hold on;
    h{n}=semilogy(BetaV',err(:,n),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);    
end
grid on
ax=gca;ax.FontSize=FontSizeC;
labelFig('$\gamma$','$\overline{\Delta f}$','\textbf{d) Averaged accuracy ($\mathbf{\delta\delta}$ RS)}',FontSizeA);
legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Interpreter','latex');

%Fig 4e
figure
for n=1:3
    semilogy(BetaV',tim(:,n),'Color',Colors(n,:));hold on;
    h{n}=semilogy(BetaV',tim(:,n),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);    
end
grid on
ax=gca;ax.FontSize=FontSizeC;
labelFig('$\gamma$','$t$ (s)','\textbf{e) Computation times ($\mathbf{\delta\delta}$ RS)}',FontSizeA);
legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Location','NorthWest','Interpreter','latex');
