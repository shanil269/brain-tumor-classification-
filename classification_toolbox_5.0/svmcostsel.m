function res = svmcostsel(X,class,kernel,pret_type,cv_type,cv_groups,num_comp)

% selection of the optimal C (cost, upper bound for the coefficients alpha)
% and kernal param (only for rbf and poly kernels) for Support Vector Machines
% by means of cross validation
%
% res = svmcostsel(X,class,kernel,pret_type,cv_type,cv_groups,num_comp)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% kernel            type of kernel: 'linear' , 'polynomial', 'rbf'
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
% output:
% res is a structure with fields:
% er                error rate in cross-validation for each C value (and
%                   kernel param value with rbf and poly kernels)
% ner               not-error rate in cross-validation for each C value (and
%                   kernel param value with rbf and poly kernels)
% average_svind     average number of support vectors for each C value (and
%                   kernel param value with rbf and poly kernels)
% kernalparam_seq   tested values of kernel parameters (only with rbf and poly kernels)
% cost_seq          tested values of cost
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

if nargin < 7; num_comp = NaN; end
C_seq = [0.1 1 10 100 1000];
if strcmp('linear',kernel)
    kernalparam_seq = [];
else
    kernalparam_seq = [0.05	0.07	0.10	0.14	0.20	0.28	0.40	0.57	0.80	1.13	1.60	2.26	3.20	4.53	6.40	9.00];
end
hwait = waitbar(0,'cross validating models','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)
for c = 1:length(C_seq)
    if ~ishandle(hwait)
        res.er = NaN;
        res.ner = NaN;
        res.average_svind = NaN;
        break
    elseif getappdata(hwait,'canceling')
        res.er = NaN;
        res.ner = NaN;
        res.average_svind = NaN;
        break
    else
        waitbar(c/length(C_seq))
        C = C_seq(c);
        if strcmp('linear',kernel)
            kernelpar = [];
            out = svmcv(X,class,kernel,C,kernelpar,pret_type,cv_type,cv_groups,num_comp);
            res.er(c) = out.class_param.er;
            res.ner(c) = out.class_param.ner;
            res.average_svind(c) = out.average_svind;
        else
            for k = 1:length(kernalparam_seq)
                kernelpar = kernalparam_seq(k);
                % disp(['cross validating C: ' num2str(C) ' and param: ' num2str(kernelpar)])
                out = svmcv(X,class,kernel,C,kernelpar,pret_type,cv_type,cv_groups,num_comp);
                res.er(c,k) = out.class_param.er;
                res.ner(c,k) = out.class_param.ner;
                res.average_svind(c,k) = out.average_svind;
            end
        end
    end
end
if ishandle(hwait)
    delete(hwait)
end
res.kernalparam_seq = kernalparam_seq;
res.cost_seq = C_seq;
res.settings.kernel = kernel;
res.settings.cv_type = cv_type;
res.settings.cv_groups = cv_groups;
res.settings.num_comp = num_comp;
res.settings.pret_type = pret_type;