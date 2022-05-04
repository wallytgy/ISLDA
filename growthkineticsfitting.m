
function [G_guess fval] = growthkineticsfitting(G0)
history=[];
options=optimset('OutputFcn',@myoutput);

T=readtable('Book1.xlsx','Sheet','sample');

bin_s= 30; %bin size [um] 
largest=1200;%end of histogram, just a rough estimate [um]
t_i=200;%timeinterval [s]
[a b]=size(T);% a is maximum number of crystals observed over time, b is index of last measured time

t_e=b*t_i-t_i;%last observed time[s]
rhowi=893000;%density of solvent [g/m3]
mw=381.4;%molecular weight of solute[g/mol]
cb=6000/rhowi; %bulk concentration [g/g]
cs=4700/rhowi; %solubility [g/g]
Supersaturation=cb-cs;

lb=[0,1,0,0.0001];
ub=[10,2,10,0.999];
opts = optimoptions(@fmincon,'Algorithm','sqp');
problem = createOptimProblem('fmincon','objective', ...
    @objfun,'x0',G0,'lb',lb,'ub',ub,'options',opts);

ms = MultiStart;
tic;
[xms,~,~,~,solsms] = run(ms,problem,1000);
toc
G_guess=xms;
fval=solsms;
function error_mu_sigma=objfun(G_guess)

%Extract for each time the length values
L_interval=[];
L_interval(:,1)=T{:,1};% CSD at time 0
csd_start=L_interval(:,1); % starting CSD

% Builds a simulated CSD based on the growth rate function and seed CSD
[a1,b1]=size(L_interval(:,1));%a1 is number of crystals including NaN fillers, NaN fillers are present due changes in number of crystals detected  
growthratefcn=@(L_g) (G_guess(1)*(Supersaturation^G_guess(2))*(1+G_guess(3)*L_g)^G_guess(4));
for i=2:1:b
    for j=1:1:a1
        G=growthratefcn(csd_start(j));
        L_interval(j,i)=csd_start(j)+G*t_i;
    end
    csd_start=L_interval(:,i);
end

% Extracts simulated (hyp) mu and sigma, CI value of lognormal distribution fitting for each CSD
mu_sigma=zeros(b,2);
for k=1:1:b
    z=L_interval(:,k);
    z1=z(~isnan(z));
    [mu_sigma(k,:) pCI_hyp]=lognfit(z1,0.05);
    [m_hyp,v_hyp]=lognstat(mu_sigma(k,1),mu_sigma(k,2));
   
end

% Extracts the mu and sigma and CI of the lognormal distribution fitting (actual)
true_mu_sigma=zeros(b,2);
for k=1:1:b
    z2=T{:,k};
    z3=z2(~isnan(z2));
    [true_mu_sigma(k,:) pCI_true]=lognfit(z3,0.05);
    [m_true,v_true]=lognstat(true_mu_sigma(k,1),true_mu_sigma(k,2));
 
end

%Minimizes squared error between actual and simulated lognormal pdf (hyp)
n_true=length(z3);
pdfparameter=[0:1:1500];
n_pdf=length(pdfparameter);
truelogndistribution=lognpdf(pdfparameter,true_mu_sigma(b,1),true_mu_sigma(b,2));
hyplogndistribution=lognpdf(pdfparameter,mu_sigma(b,1),mu_sigma(b,2));
difference_1=zeros(n_pdf,1);
for k1=1:1:n_pdf
difference_1(k1)=(truelogndistribution(k1)-hyplogndistribution(k1))^2;
end
error_mu_sigma=sum(difference_1);
end  
end