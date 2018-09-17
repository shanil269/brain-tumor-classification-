function res = knnksel(X,class,dist_type,pret_type,cv_type,cv_groups)

% selection of the optimal number of neighbours for k-Nearest Neighbours 
% by means of cross-validation
%
% res = knnksel(X,class,dist_type,pret_type,cv_type,cv_groups)
%
% input: 
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
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
% cv_type           type of cross validation
%                   'vene' for venetian blinds'
%                   'cont' for contiguous blocks
%                   'boot' for bootstrap with resampling
%                   'rand' for random sampling (montecarlo) of 20% of samples
% cv_groups         number of cv groups
%                   if cv_groups == samples: leave-one-out
%                   if 'boot' or 'rand' are selected as cv_type, cv_groups 
%                   sets the number of iterations
%
% output:
% res is a structure with fields:
% er            error rate in cross-validation for each k value [1 x 10]
% ner           not-error rate in cross-validation for each k value [1 x 10]
% settings      settings
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
Kdisp = [1:10];
hwait = waitbar(0,'cross validating models','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0);
for k = 1:length(Kdisp)
    if ~ishandle(hwait)
        res.er = NaN;
        res.ner = NaN;
        res.class_pred = NaN;
        break
    elseif getappdata(hwait,'canceling')
        res.er = NaN;
        res.ner = NaN;
        res.class_pred = NaN;
        break
    else
        waitbar(k/length(Kdisp))
        k_val = Kdisp(k);
        out = knncv(X,class,k_val,dist_type,pret_type,cv_type,cv_groups);
        res.er(k) = out.class_param.er;
        res.ner(k) = out.class_param.ner;
        res.class_pred{k}=out.class_pred;
    end
end
if ishandle(hwait)
    delete(hwait)
end
res.settings.pret_type = pret_type;
res.settings.cv_type = cv_type;
res.settings.cv_groups = cv_groups;
res.settings.dist_type = dist_type;