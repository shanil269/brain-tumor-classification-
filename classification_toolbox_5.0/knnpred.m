function pred = knnpred(Xtest,X,class,K,dist_type,pret_type)

% prediction of new samples with k-Nearest Neighbours (kNN)
%
% pred = knnpred(Xtest,X,class,K,dist_type,pret_type)
%
% input:
% Xtest             dataset to be predicted [n_test x variables]
% X                 training dataset [samples x variables]
% class             training class vector [samples x 1]
% K                 number of neighbors
% dist_type         'euclidean' Euclidean distance
%                   'mahalanobis' Mahalanobis distance
%                   'cityblock' City Block metric
%                   'minkowski' Minkowski metric
%                   'sm' sokal-michener for binary data
%                   'rt' rogers-tanimoto for binary data
%                   'jt' jaccard-tanimoto for binary data
%                   'gle' gleason-dice sorenson for binary data
%                   'ct4' consonni todeschini for binary data
%                   'ac' austin colwell for binary data
% pret_type         data pretreatment 
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' for autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
%
% output:
% pred structure containing:
% class_pred        predicted class [n_test x 1]
% neighbors         list of k neighbors for each predicted sample [n_test x k]
% D                 distance matrix [n_test x samples]
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

[n,p] = size(Xtest);
[X_scal_train,param] = data_pretreatment(X,pret_type);
X_scal = test_pretreatment(Xtest,param);
D = knn_calc_dist(X_scal_train,X_scal,dist_type);
neighbors = zeros(n,K);
for i=1:n
    D_in = D(i,:);
    [d_tmp,n_tmp] = sort(D_in);
    neighbors(i,:) = n_tmp(1:K);
    d_neighbors = d_tmp(1:K);
    class_calc(i) = knnclass(class(neighbors(i,:)),d_neighbors,max(class));
end
pred.neighbors  = neighbors;
pred.D = D;
pred.class_pred = class_calc';
