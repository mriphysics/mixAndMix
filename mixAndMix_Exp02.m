%MIXANDMIX_EXP02 script performs the experiment included in Fig. 2 of the 
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
C(end/2:end)=2;
M=size(C,1);
Beta=M/N;

tol=1e-4;
    
%SPECTRODE    
esd=ESDSpectrode(C,N,tol,0);
    
%OURS STANDARD
esd{2}=ESDMixAndMix(C,N,tol);
    
%NO HOMOTOPY CONTINUATION
esd{3}=ESDMixAndMix(C,N,tol,[],[],[],tol,1);

meth={'SPECTRODE','MIXANDMIX','MIXANDMIX No HC'};
%Fig 2a
figure
hold on
for n=1:3
    N=length(esd{n}.grid);sub=ceil(N/10);
    plot(esd{n}.grid,esd{n}.dens,'Color',Colors(n,:));hold on
    h{n}=plot(esd{n}.grid(1:sub:end),esd{n}.dens(1:sub:end),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
end
xlim([0 6])
grid on
ax=gca;ax.FontSize=FontSizeC;
labelFig('$x$','$f(x)$','\textbf{a) Estimates}',FontSizeA);
legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Interpreter','latex');

%Figs 2b-e
tolV=[1 1e-1 1e-2 1e-3];
tit={'\textbf{b) $\mathbf{z=2.2+i}$ }','\textbf{c) $\mathbf{z=2.2+0.1i}$ }','\textbf{d) $\mathbf{z=2.2+0.01i}$ }','\textbf{e) $\mathbf{z=2.2+0.001i}$ }'};
suffV={'b','c','d','e'};
NV=length(tolV);
for n=1:NV
    tol=tolV(n);
    suff=suffV{n};
    plotObjective([1 2]',0.5,2.2+1i*tol,[],[],1,tit{n})
end
