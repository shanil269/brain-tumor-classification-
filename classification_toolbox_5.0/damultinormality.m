function distSort = damultinormality(X)

% test for multinormality distribution based on squared generalized distance and chi-square percentiles;
% data are multinormally distributed if:
% 1. a plot of the ordered squared distances and the chi-square percentiles is nearly linear 
% 2. roughly half of the distances are less then or equal to chi-square percentile of 0.5
% REF: Applied Multivariate Statistical Analysis - Johnson,R.A.;Wichern,D.W.
% 
% distSort = damultinormality(X)
%
% input:
% X                 dataset [samples x variables]
%
% output:
% distSort          table [samples x 3] with:
%                   first column:  ID of samples
%                   second column: sorted squared generalized distances (from minimum to maximum)
%                   third column:  chi-square percentiles, with degree of freedom equal to the number of variables
%
% The main routine is class_gui
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Classification toolbox for MATLAB
% version 5.0 - July 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

[nobj,nvar] = size(X);
ave = mean(X);
S = cov(X);
for i=1:nobj                        
    dist(i,1) = i;
    vec = (X(i,:) - ave)';
    dist(i,2) = vec'*inv(S)*vec; % squared generalized distance
end
[sorthere,pos] = sort(dist(:,2));
distSort = dist(pos,:);
for i=1:nobj
    pr     = (i - 0.5)/nobj;
    chi(i) = chi2inv(pr,nvar); % calculates chi-square percentiles
end
distSort(:,3) = chi';
chiTest = chi2inv(0.5,nvar);        
Low = length(find(distSort(:,2) < chiTest)); % test with chi-square percentile of 0.5
percLow = Low/nobj;

figure
set(gcf,'color','white'); box on;
plot(distSort(:,2),distSort(:,3),'o','MarkerEdgeColor','r','MarkerSize',3,'MarkerFaceColor','w')
xlabel('squared generalized distances');
ylabel('chi-square percentiles');
M = max(max(distSort(:,2:3)));
M = M+M/10;
H=line([0 M],[0 M],'LineStyle','-','color','k');
axis([0 M 0 M])
title('test of multinormality');
str=([sprintf('%1.0f',percLow*100) '% dist < ',num2str(chiTest),' [chi-square(0.5)]']);
text(M/20,M-M/20,str);
