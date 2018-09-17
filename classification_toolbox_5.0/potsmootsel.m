function res = potsmootsel(X,class,type,perc,pret_type,cv_type,cv_groups,num_comp)

% selection of optimal smoothing parameter for potential functions
% by means of cross-validation
%
% res = potsmootsel(X,class,type,perc,pret_type,cv_type,cv_groups,num_comp)
%
% Input
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% type              kernel type
%                   'gaus' gaussian kernel
%                   'tria' triangular kernel
% perc              percentile to define the class boundary (e.g. 95)
%                   small percentiles gives smaller class spaces
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
% optional
% num_comp          define the number of PCs to apply svm on Principal Components;
%                   NaN: do not apply svm on Principal Components;
%                   0: autodetect PCs by taking those components with eigenvalue higher than the average eigenvalue
%                   num_comp: integer number to define a fixed number of components to be used;
%
% Output
% res is a structure with fields:
% er                class error rate in cross-validation, i.e. 1 - average of class specificity and sensitivity [tested smoothing parameters x classes]
% specificity       class specificity in cross-validation [tested smoothing parameters x classes]
% sensitivity       class sensitivity in cross-validation [tested smoothing parameters x classes]
% smoot_prod        product of class potentials in cross-validation [tested smoothing parameters x classes]
% settings          settings used in optimisation, settings.smoot_range contains the tested smoothing values
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

if nargin < 8; num_comp = NaN; end
smoot_range = [0.1:0.1:1.2];
hwait = waitbar(0,'cross validating models','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)
for k = 1:length(smoot_range)
    if ~ishandle(hwait)
        res.er = NaN;
        res.sensitivity = NaN;
        res.specificity = NaN;
        res.smoot_prod = NaN;
        break
    elseif getappdata(hwait,'canceling')
        res.er = NaN;
        res.sensitivity = NaN;
        res.specificity = NaN;
        res.smoot_prod = NaN;
        break
    else
        waitbar(k/length(smoot_range))
        smoot_here = ones(1,max(class))*smoot_range(k);
        out = potcv(X,class,type,smoot_here,perc,pret_type,cv_type,cv_groups,num_comp);
        res.er(k,:) = out.class_param.er_smootsel;
        res.sensitivity(k,:) = out.class_param.sn_smootsel;
        res.specificity(k,:) = out.class_param.sp_smootsel;
        res.smoot_prod(k,:) = out.smoot_prod;
    end
end
if ishandle(hwait)
    delete(hwait)
end
res.settings.smoot_range = smoot_range;
res.settings.type = type;
res.settings.perc = perc;
res.settings.pret_type = pret_type;
res.settings.cv_type = cv_type;
res.settings.cv_groups = cv_groups;
res.settings.num_comp = num_comp;
end
