%MIXANDMIX_EXP03 script performs the experiment included in Figs. 3a and 3b
%of the manuscript "Numerical techniques for the computation of sample 
%spectral distributions of population mixtures", L Cordero-Grande, 
%unpublished, 2018.

clearvars
addpath(genpath('.'));%Add code
quick=0;%Set to 1 for quick inspection of results
styleFigRoutine;

M=100;
if quick
    BetaV=0.05:0.15:0.95;
    ju=2;
else
    BetaV=0.05:0.1:0.95;
    ju=4;
end
BetaV=flip([1./BetaV 1 flip(BetaV)]);
NB=length(BetaV);

tim=zeros(NB,3);err=zeros(NB,3);
for n=1:NB
    Beta=BetaV(n);
    N=round(M/Beta);
    C=ones(M,1);
    M=size(C,1);
    Beta=M/N;
    
    %SPECTRODE    
    if Beta<1;tolSpe=1e-6;else tolSpe=1e-5;end
    esd=ESDSpectrode(C,N,tolSpe);
    tim(n,1)=timeit(@()ESDSpectrode(C,N,tolSpe));
    
    %QUEST
    esdAux=ESDQuest(C,N);
    tim(n,2)=timeit(@()ESDQuest(C,N));
    esd{2}=esdAux{1};
    
    %OURS STANDARD
    tolFpa=1e-5;
    NL=3;
    esd{3}=ESDMixAndMix(C,N,tolFpa,NL);
    tim(n,3)=timeit(@()ESDMixAndMix(C,N,tolFpa,NL));
    
    %MP
    esdRef=ESDMarcenkoPastur(Beta,M*M);
    
    for m=1:3
        dens=interp1(esd{m}.grid,esd{m}.dens,esdRef.grid,'linear',0);
        err(n,m)=mean(abs(dens-esdRef.dens));
    end
end

meth={'SPECTRODE','QuEST','MIXANDMIX'};
BetaVPrev=BetaV;
BetaV=(1:numel(BetaV));

%Fig 3a
figure
for n=1:3
    semilogy(BetaV',err(:,n),'Color',Colors(n,:));hold on;
    h{n}=semilogy(BetaV',err(:,n),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);    
end
grid on
xt=set(gca,'xtick',BetaV(1:ju:end),'xticklabel',arrayfun(@(x) num2str(x,'%.2f'),BetaVPrev(1:ju:end),'un',0));
ax=gca;ax.FontSize=FontSizeC;
labelFig('$\gamma$','$\overline{\Delta f}$','\textbf{a) Averaged accuracy (MP)}',FontSizeA);
legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Location','NorthWest','Interpreter','latex');
xlim([1 length(BetaV)])

%Fig 3b
figure
for n=1:3
    semilogy(BetaV',tim(:,n),'Color',Colors(n,:));hold on;
    h{n}=semilogy(BetaV',tim(:,n),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);    
end
grid on
xt=set(gca,'xtick',BetaV(1:ju:end),'xticklabel',arrayfun(@(x) num2str(x,'%.2f'),BetaVPrev(1:ju:end),'un',0));
ax=gca;ax.FontSize=FontSizeC;
labelFig('$\gamma$','$t$ (s)','\textbf{b) Computation times (MP)}',FontSizeA);
legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Location','NorthWest','Interpreter','latex');
xlim([1 length(BetaV)])
