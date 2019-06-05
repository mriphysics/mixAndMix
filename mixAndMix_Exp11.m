%MIXANDMIX_EXP11 script performs the experiment included in Fig. 5 of the 
%manuscript "Numerical techniques for the computation of sample spectral 
%distributions of population mixtures", L Cordero-Grande, unpublished, 
%2018.

clearvars
addpath(genpath('.'));%Add code
styleFigRoutine;

%COMB MODEL
MM=100;
t_min=1/10;
t_max=10;
t=linspace(t_min,t_max,MM);

M=100;

BetaV=[0.025 0.5 0.975];

suff={'a','b','c'};
gamm={'0.025','0.5','0.975'};

tolSpeV=[1e-6 1e-6 1e-8];
xl{1}=[1.2 3.5];
xl{2}=[3.5e-2 1];
xl{3}=[3e-4 3e-2];

meth{1}={'SPECTRODE $10^{-3}$','QuEST','MIXANDMIX','SPECTRODE $10^{-6}$'};
meth{2}={'SPECTRODE $10^{-3}$','QuEST','MIXANDMIX','SPECTRODE $10^{-6}$'};
meth{3}={'SPECTRODE $10^{-3}$','QuEST','MIXANDMIX','SPECTRODE $10^{-8}$'};

for v=1:length(BetaV)
    Beta=BetaV(v);

    N=round(M/Beta);
    C=ones(M,1);
    for p=1:MM;C(M*(p-1)/MM+1:M*p/MM)=t(p);end    
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
    
    %SPECTRODE    
    tolSpe=tolSpeV(v);
    esdAux=ESDSpectrode(C,N,tolSpe);
    esd{4}=esdAux{1};

    %Figs. 5a-c
    figure
    for n=1:4
        N=length(esd{n}.grid);sub=ceil(N/10);
        fprintf('Method: %s. Number of grid points: %d\n',meth{v}{n},length(esd{n}.grid));        
        h{n}=semilogx(esd{n}.grid,max(esd{n}.dens,1e-10),'Color',Colors(n,:),'LineStyle',lines{n},'LineWidth',2);hold on;
    end
    grid on
    ax=gca;ax.FontSize=FontSizeC;      
    labelFig('$x$','$f(x)$',sprintf('\\textbf{%s) Estimates (Comb $\\mathbf{\\gamma=%s}$)}',suff{v},gamm{v}),FontSizeA);
    hh=legend([h{1} h{2} h{3} h{4}],meth{v},'FontSize',FontSizeB,'Interpreter','latex');
    xlim(xl{v});
end
