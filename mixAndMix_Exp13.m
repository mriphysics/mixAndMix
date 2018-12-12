%MIXANDMIX_EXP13 script performs the experiment included in Fig. 6c of the 
%manuscript "Numerical techniques for the computation of sample spectral 
%distributions of population mixtures", L Cordero-Grande, unpublished, 
%2018.

clearvars
addpath(genpath('.'));%Add code
quick=0;%Set to 1 for quick inspection of results
styleFigRoutine;
gpu=gpuDeviceCount;%Detects whether gpu computations are possible %NOTE THIS EXPERIMENT TRIES TO SHOW PARALLELIZATION, SO MORE SENSE WITH GPU

%POPULATION MIXTURE MODEL
%typV{1}='SinglMassSpann';%C_k={1+k,...,K-1+k,K+k} (mod K summation)
typV{1}='MultiMassShift';%C_k={1+k,...,K-1+k,K+k} (mod K summation)
%typV{3}='MultiMassSpann';%C_k={1,...,K-1,K}
NP=length(typV);

if quick;KV=[1 2];else KV=[1 2 3 4 5 6];end
NK=length(KV);

rho=0.2;
M=120;
if quick;BetaV=0.1:0.4:0.9;else BetaV=0.1:0.2:0.9;end
NB=length(BetaV);

tim=zeros(NK,NB);

for p=1:NP
    typ=typV{p};
    for k=1:NK
        K=KV(k);
        t=1:K;
        NT=length(t);

        for n=1:NB
            Beta=BetaV(n);        
            N=NT*round(M/(Beta*NT));  
            C=eye(NT);    
            C=repmat(C,[1 1 1 NT]);
            if strcmp(typ,'SinglMassSpann')
                for tt=1:NT;C(:,:,1,tt)=t(tt)*C(:,:,1,tt);end
            elseif strcmp(typ,'MultiMassShift')
                for tt=1:NT
                    for ll=1:NT;C(tt,tt,1,ll)=mod(tt+ll-2,NT)+1;end
                end
            elseif strcmp(typ,'MultiMassSpann')
                for tt=1:NT;C(tt,tt,1,:)=tt;end
            end
            C=diagm(repmat(diagm(C),[1 M/NT]));      
            C=addCorrelation(C,rho,0.25);

            M=size(C,1);
            if gpu;C=gpuArray(C);end
            Beta=M/N;     

            %OURS STANDARD
            tolFpa=1e-4;
            NL=3;
            esd=ESDMixAndMix(C,N,tolFpa,NL);        
            tim(k,n)=timeit(@()ESDMixAndMix(C,N,tolFpa,NL));
        end
    end

    %Fig 6c
    figure
    for n=1:NB
        h{n}=plot(KV,tim(:,n));hold on;   
        meth{n}=sprintf('$\\gamma=%.1f$',BetaV(n));
    end 
    
    grid on
    ax=gca;ax.FontSize=FontSizeC;      
    labelFig('$K$','$t$ (s)','\textbf{c) Computation times}',FontSizeA);
    if quick;hh=legend([h{1} h{2} h{3}],meth,'FontSize',FontSizeB,'Location','SouthEast','Interpreter','latex');else hh=legend([h{1} h{2} h{3} h{4} h{5}],meth,'Location','SouthEast','FontSize',FontSizeB,'Interpreter','latex');end
end
