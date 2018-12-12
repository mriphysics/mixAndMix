%MIXANDMIX_EXP01 script performs the experiment included in Fig. 1 of the 
%manuscript "Numerical techniques for the computation of sample spectral 
%distributions of population mixtures", L Cordero-Grande, unpublished, 
%2018.

clearvars
addpath(genpath('.'));%Add code
quick=0;%Set to 1 for quick inspection of results
styleFigRoutine;

M=100;
Beta=0.5;
N=M/Beta;
C=ones(M,1);
M=size(C,1);
Beta=M/N;

if quick;tolV=[1e-1 1e-2];else tolV=[1e-1 1e-2 1e-3 1e-4 1e-5];end
NT=length(tolV);

tim=zeros(NT,3);
err=zeros(NT,3);
for n=1:NT
    tol=tolV(n);
    
    %SPECTRODE TIME AND ERROR    
    esd=ESDSpectrode(C,N,tol);
    tim(n,1)=timeit(@()ESDSpectrode(C,N,tol));
    grd=esd{1}.grid;
    esdRef=ESDMarcenkoPastur(Beta,grd);    
    err(n,1)=mean(abs(esd{1}.dens-esdRef.dens));
    if n==NT
        esdF{1}.grid=grd;
        esdF{1}.err=max(abs(esd{1}.dens-esdRef.dens),10^(-10));
    end
    
    %OURS TIME AND ERROR
    esd=ESDMixAndMix(C,N,tol);
    tim(n,2)=timeit(@()ESDMixAndMix(C,N,tol));
    grd=esd.grid;
    esdRef=ESDMarcenkoPastur(Beta,grd);    
    err(n,2)=mean(abs(esd.dens-esdRef.dens));
    if n==NT
        esdF{2}.grid=grd;
        esdF{2}.err=max(abs(esd.dens-esdRef.dens),10^(-10));
    end
    
    %STANDARD FIXED POINT TIME AND ERROR
    esd=ESDMixAndMix(C,N,tol,[],[],[],[],[],0,[],1/tol);
    tim(n,3)=timeit(@()ESDMixAndMix(C,N,tol,[],[],[],[],[],0,[],1/tol));
    grd=esd.grid;
    esdRef=ESDMarcenkoPastur(Beta,grd);    
    err(n,3)=mean(abs(esd.dens-esdRef.dens));
    if n==NT
        esdF{3}.grid=grd;
        esdF{3}.err=max(abs(esd.dens-esdRef.dens),10^(-10));
    end
end

meth={'SPECTRODE','MIXANDMIX Q=2','MIXANDMIX Q=0'};

%Fig 1a
figure
for n=1:3
    loglog(tolV,err(:,n),'Color',Colors(n,:));hold on;
    h{n}=loglog(tolV,err(:,n),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
end
grid on
ax=gca;ax.FontSize=FontSizeC;
labelFig('$\epsilon$','$\overline{\Delta f}$','\textbf{a) Averaged accuracy}',FontSizeA);
hh=legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Location','NorthWest','Interpreter','latex');
pos=get(hh,'Position');
pos(1)=pos(1)+0;
pos(2)=pos(2)-0.1;
set(hh,'Position',pos);

%Fig 1b
figure
for n=1:3
    loglog(tolV,tim(:,n),'Color',Colors(n,:));hold on;
    h{n}=loglog(tolV,tim(:,n),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
end
grid on
ax=gca;ax.FontSize=FontSizeC;
labelFig('$\epsilon$','$t$ (s)','\textbf{b) Computation times}',FontSizeA);
legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Interpreter','latex')

%Fig 1c
figure
cont=1;
for n=1:3
    N=length(esdF{n}.grid);sub=ceil(N/10);
    semilogy(esdF{n}.grid,esdF{n}.err,'Color',Colors(n,:));hold on
    h{n}=semilogy(esdF{n}.grid(1:sub:end),esdF{n}.err(1:sub:end),'*','Color',Colors(n,:),'Marker',markers{n},'MarkerSize',MarkerSize,'LineWidth',LineWidth);
end
xlim([0 3])
grid on
ax=gca;ax.FontSize=FontSizeC;
labelFig('$x$','$\Delta f(x)$','\textbf{c) Accuracy}',FontSizeA);
legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Interpreter','latex')

