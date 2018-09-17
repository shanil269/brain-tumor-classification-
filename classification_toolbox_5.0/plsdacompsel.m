function res = plsdacompsel(X,class,pret_type,cv_type,cv_groups,assign_method)

% selection of the optimal number of components (latent variables) for PLSDA
% by means of cross-validation
%
% res = plsdacompsel(X,class,pret_type,cv_type,cv_groups,assign_method)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
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
% assign_method     assignation method
%                   'bayes' samples are assigned on thresholds based on Bayes Theorem
%                   'max' samples are assigned to the class with maximum yc
%
% output:
% res is a structure with fields:
% er                error rate in cross-validation [1 x components]
% ner               not-error rate in cross-validation [1 x components]
% not_ass           ratio of not-assigned samples [1 x components]
% settings          settings
%
% based on Frans Van Den Berg mypls routine
% http://www.models.kvl.dk/
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
r = min(n,p);
if r > 20
    r = 20;
end
if r > 2
    r = r - 1;
end
hwait = waitbar(0,'cross validating models','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0);
for k = 1:r
    if ~ishandle(hwait)
        res.er = NaN;
        res.ner = NaN;
        res.not_ass = NaN;
        break
    elseif getappdata(hwait,'canceling')
        res.er = NaN;
        res.ner = NaN;
        res.not_ass = NaN;
        break
    else
        waitbar(k/r)
        out = plsdacv(X,class,k,pret_type,cv_type,cv_groups,assign_method);
        res.er(k) = out.class_param.er;
        res.ner(k) = out.class_param.ner;
        res.not_ass(k) = out.class_param.not_ass;
    end
end
if ishandle(hwait)
    delete(hwait)
end
res.settings.pret_type = pret_type;
res.settings.cv_type = cv_type;
res.settings.cv_groups = cv_groups;
res.settings.assign_method = assign_method;