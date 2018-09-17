function res = uneqcompsel(X,class,pret_type,cv_type,cv_groups)

% selection of the optimal number of PC components for UNEQ
% by means of cross-validation
%
% res = uneqcompsel(X,class,pret_type,cv_type,cv_groups)
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
%
% output:
% res is a structure with fields:
% er                class error rate in cross-validation, i.e. 1 - average of class specificity and sensitivity [components x classes]
% specificity       class specificity in cross-validation [components x classes]
% sensitivity       class sensitivity in cross-validation [components x classes]
% settings          settings
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
for g=1:max(class); c(g) = length(find(class==g));end
n = min(c);
r = min(n,p);
if r > 20
    r = 20;
end
if r > 2
    r = r - 1;
end
hwait = waitbar(0,'cross validating models','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)
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
        num_comp = k*ones(1,max(class));
        out = uneqcv(X,class,num_comp,pret_type,cv_type,cv_groups,'class modeling');
        res.er(k,:) = out.class_param.er_compsel;
        res.sensitivity(k,:) = out.class_param.sn_compsel;
        res.specificity(k,:) = out.class_param.sp_compsel;
    end
end
if ishandle(hwait)
    delete(hwait)
end
res.settings.cv_type = cv_type;
res.settings.cv_groups = cv_groups;
res.settings.pret_type = pret_type;

