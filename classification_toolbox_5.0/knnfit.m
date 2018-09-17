function model = knnfit(X,class,K,dist_type,pret_type)

% fit k-Nearest Neighbours (kNN)
%
% model = knnfit(X,class,K,dist_type,pret_type)
%
% input:            
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
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
% model is a structure containing
% neighbors         list of neighbors [samples x k]
% D                 distance matrix [samples x samples]
% class_calc        calculated class [samples x 1]
% class_param       classification parameters
% settings          structure with model settings
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

[n,p] = size(X);
[X_scal,param] = data_pretreatment(X,pret_type);
D = knn_calc_dist(X_scal,X_scal,dist_type);
neighbors = zeros(n,K);
for i=1:n
    D_in = D(i,:);
    [d_tmp,n_tmp] = sort(D_in);
    % delete i-th object
    ith = find(n_tmp==i);
    d_tmp(ith) = [];  
    n_tmp(ith) = [];
    neighbors(i,:) = n_tmp(1:K);
    d_neighbors = d_tmp(1:K);
    class_calc(i) = knnclass(class(neighbors(i,:)),d_neighbors,max(class));
end

class_param = calc_class_param(class_calc,class);

model.type = 'knn';
model.neighbors  = neighbors;
model.D = D;
model.class_calc = class_calc';
model.class_param = class_param;
model.settings.pret_type = pret_type;
model.settings.param = param;
model.settings.K = K;
model.settings.dist_type = dist_type;
model.settings.raw_data = X;
model.settings.class = class;
model.cv = [];
model.labels.variable_labels = {};
model.labels.sample_labels = {};
