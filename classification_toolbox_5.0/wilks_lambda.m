function [lambda,rank] = wilks_lambda(X,class)

% ranking of variables on the basis of wilk's lambda
%
% X         data matrix [n x p]
% class     class vector [n x 1]
%
% lambda    wilk's lambda values for the ranked varaibles
% rank      variables ranked on the basis of wilk's lambda values
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

in = find(class > 0);
X = X(in,:);
[n,p] = size(X);

blocks(1:20) = 0;
for i=1:length(class)
    if class(i) > 0
        blocks(class(i)) = class(class(i)) + 1;  
    end
end

nclass = 0;
for k=1:length(blocks)
    if blocks(k) > 0
        nclass = nclass + 1;
    end    
end

for j=1:p
    X_var = X(:,j);
%    X_var = X;
    C = cov(X_var);
    W = 0;
    for k=1:nclass
        Xin = X_var(find(class==k),:);
        Cg = cov(Xin);
        W = W + Cg.*(size(Xin,1)-1);
    end
    C = C.*(size(X_var,1)-1);
    L(j) = det(W)/det(C);
    %L = det(W)/det(C); 
end

[lambda,rank] = sort(L);
