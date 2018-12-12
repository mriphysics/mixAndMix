%MIXANDMIX_EXP12 script performs the experiment included in Figs. 6a and 6b
%of the manuscript "Numerical techniques for the computation of sample 
%spectral distributions of population mixtures", L Cordero-Grande, 
%unpublished, 2018.

clearvars
addpath(genpath('.'));%Add code
styleFigRoutine;
gpu=gpuDeviceCount;%Detects whether gpu computations are possible

%POPULATION MIXTURE MODEL
%typV{1}='SinglMassSpann';%C_k={k,...,k,k}
typV{1}='MultiMassShift';%C_k={1+k,...,K-1+k,K+k} (mod K summation)
%typV{3}='MultiMassSpann';%C_k={1,...,K-1,K}
NP=length(typV);

t=1:6;
NT=length(t);

suff={'a','b'};
typE={'DIAG','CORR'};

rhoV=[0 0.2];
NRR=length(rhoV);

M=120;
BetaV=0.5;
NB=length(BetaV);

meth={'Estimates','Simulations'};
cont=1;
for p=1:NP
    typ=typV{p};
    for r=1:NRR
        rho=rhoV(r);       
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

            %SIMULATION
            NR=16;
            esdSim=ESDSimulated(C,N,[],NR);
            
            esd.dens(esd.grid>esd.thre)=[];
            esd.grid(esd.grid>esd.thre)=[];

            %Figs. 6a and 6b
            figure
            h{1}=plot(esd.grid,esd.dens,'LineWidth',1.5);hold on
            h{2}=histogram(abs(esdSim.simu),ceil(M*NR/40),'Normalization','pdf','FaceColor','None','EdgeColor',Colors(2,:)); 
            grid on
            ax=gca;ax.FontSize=FontSizeC;      
            labelFig('$x$','$f(x)$',sprintf('\\textbf{%s) Estimates (%s)}',suff{cont},typE{r}),FontSizeA);
            hh=legend([h{1} h{2}],meth,'FontSize',FontSizeB,'Interpreter','latex');
            cont=cont+1;
        end
    end
end
