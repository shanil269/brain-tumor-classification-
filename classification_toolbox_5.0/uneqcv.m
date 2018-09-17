function cv = uneqcv(X,class,comp,pret_type,cv_type,cv_groups,assign_method)

% cross-validation for UNEQ
%
% cv = uneqcv(X,class,comp,pret_type,cv_type,cv_groups,assign_method)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% comp              number of components for each class model [1 x classes]
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
%                   'class modeling', samples are assigned to class(es) with normalised T2 Hotelling lower
%                   than a class threshold. T2 Hotelling are normalised over their 95% confidence limits. 
%                   Samples can be predicted in none or multiple classes. Threshold is found for each class by maximizing specificity and sensitivity
%                   'dist', samples are always assigned to the closest class, i.e. the class with the lowest normalised 
%                   T2 Hotelling. T2 Hotelling are normalised over their 95% confidence limits.
%
% output:
% cv structure containing:
% class_pred        predicted class vector [samples x 1]
% class_param       classification parameters
% settings          cv settings
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

y = class;
x = X;
nobj=size(x,1);
if strcmp(cv_type,'boot')
    hwait = waitbar(0,'bootstrap validation');
    out_bootstrap = zeros(nobj,1);
    assigned_class = [];
    binary_class = [];
    class_true = [];
    for i=1:cv_groups
        waitbar(i/cv_groups)
        out = ones(nobj,1);
        whos_in = [];
        for k=1:nobj
            r = ceil(rand*nobj);
            whos_in(k) = r;
        end
        out(whos_in) = 0;
        % counters for left out samples
        out_bootstrap(find(out == 1)) = out_bootstrap(find(out == 1)) + 1;
        x_out = x(find(out == 1),:);
        x_in  = x(whos_in,:);
        y_in  = y(whos_in,:);
        model = uneqfit(x_in,y_in,comp,pret_type,assign_method);
        pred = uneqpred(x_out,model);
        assigned_class = [assigned_class; pred.class_pred];
        binary_class = [binary_class; pred.settings.binary_assignation];
        class_true = [class_true; class(find(out == 1))];
    end
    class = class_true;
    assigned_class = assigned_class';
    delete(hwait);
elseif strcmp(cv_type,'rand')
    hwait = waitbar(0,'montecarlo validation');
    assigned_class = [];
    binary_class = [];
    out_rand = zeros(nobj,1);
    perc_in = 0.8;
    take_in = round(nobj*perc_in);
    class_true = [];
    for i=1:cv_groups
        waitbar(i/cv_groups)
        out = ones(nobj,1);
        whos_in = randperm(nobj);
        whos_in = whos_in(1:take_in);
        out(whos_in) = 0;
        % counters for left out samples
        out_rand(find(out == 1)) = out_rand(find(out == 1)) + 1;
        x_out = x(find(out == 1),:);
        x_in  = x(whos_in,:);
        y_in  = y(whos_in,:);
        model = uneqfit(x_in,y_in,comp,pret_type,assign_method);
        pred = uneqpred(x_out,model);
        assigned_class = [assigned_class; pred.class_pred];
        binary_class = [binary_class; pred.settings.binary_assignation];
        class_true = [class_true; class(find(out == 1))];
    end
    class = class_true;
    assigned_class = assigned_class';
    delete(hwait);
else
    obj_in_block = fix(nobj/cv_groups);
    left_over = mod(nobj,cv_groups);
    st = 1;
    en = obj_in_block;
    for i = 1:cv_groups
        in = ones(size(x,1),1);
        if strcmp(cv_type,'vene') % venetian blinds
            out = [i:cv_groups:nobj];
        else % contiguous blocks
            if left_over == 0
                out = [st:en];
                st =  st + obj_in_block;  en = en + obj_in_block;
            else
                if i < cv_groups - left_over
                    out = [st:en];
                    st =  st + obj_in_block;  en = en + obj_in_block;
                elseif i < cv_groups
                    out = [st:en + 1];
                    st =  st + obj_in_block + 1;  en = en + obj_in_block + 1;
                else
                    out = [st:nobj];
                end
            end
        end
        in(out) = 0;
        x_in = x(find(in),:);
        y_in = y(find(in),:);
        x_out = x(find(in == 0),:);
        model = uneqfit(x_in,y_in,comp,pret_type,assign_method);
        pred = uneqpred(x_out,model);
        assigned_class(find(in == 0)) = pred.class_pred;
        binary_class(find(in == 0),:) = pred.settings.binary_assignation;
    end
end
cv.class_param = calc_class_param(assigned_class',class);
for g=1:size(binary_class,2)
    class_here = 2*ones(length(class),1);
    class_here(find(class == g)) = 1;
    class_here_calc = binary_class(:,g);
    class_here_calc(find(class_here_calc == 0)) = 2;
    cp_class = calc_class_param(class_here_calc,class_here);
    cv.class_param.sn_compsel(g) = cp_class.sensitivity(1);
    cv.class_param.sp_compsel(g) = cp_class.specificity(1);
    cv.class_param.er_compsel(g) = cp_class.er;
end
cv.class_pred = assigned_class';
cv.settings.cv_groups = cv_groups;
cv.settings.cv_type = cv_type;
cv.settings.num_comp = comp;
cv.settings.scal = pret_type;