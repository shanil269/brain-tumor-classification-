function cv = dacv(X,class,cv_type,cv_groups,class_prob,method,num_comp,pret_type)

% cross validation for Discriminant Analysis 
%
% cv = dacv(X,class,cv_type,cv_groups,class_prob,method,num_comp,pret_type)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% cv_type           type of cross validation
%                   'vene' for venetian blinds'
%                   'cont' for contiguous blocks
%                   'boot' for bootstrap with resampling
%                   'rand' for random sampling (montecarlo) of 20% of samples
% cv_groups         number of cv groups
%                   if cv_groups == samples: leave-one-out
%                   if 'boot' or 'rand' are selected as cv_type, cv_groups 
%                   sets the number of iterations
% class_prob        if class_prob = 1 equal probability, if class_prob = 2 proportional probability
% method            'linear' (LDA) or 'quadratic' (QDA)
% optional:
% num_comp          DA is calculated on the first num_comp principal components
% pret_type         data pretreatment 
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' for autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
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

nobj = size(X,1);
if strcmp(cv_type,'boot')
    hwait = waitbar(0,'bootstrap validation');
    out_bootstrap = zeros(nobj,1);
    class_pred = [];
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
        boot_how_many_out(i)=length(find(out == 1));
        out_bootstrap(find(out == 1)) = out_bootstrap(find(out == 1)) + 1;
        Xext = X(find(out == 1),:);
        class_ext = class(find(out == 1));
        Xtrain  = X(whos_in,:);
        class_train  = class(whos_in);
        if nargin == 8
            model = dafit(Xtrain,class_train,class_prob,method,num_comp,pret_type);
        else
            model = dafit(Xtrain,class_train,class_prob,method);
            num_comp = 0;
            pret_type = 'none';
        end
        pred = dapred(Xext,model);
        class_pred = [class_pred; pred.class_pred];
        class_true = [class_true; class_ext];
    end
    class = class_true;
    delete(hwait);
elseif strcmp(cv_type,'rand')
    hwait = waitbar(0,'montecarlo validation');
    out_rand = zeros(nobj,1);
    perc_in = 0.8;
    take_in = round(nobj*perc_in);
    class_pred = [];
    class_true = [];
    for i=1:cv_groups
        waitbar(i/cv_groups)
        out = ones(nobj,1);
        whos_in = randperm(nobj);
        whos_in = whos_in(1:take_in);
        out(whos_in) = 0;
        % counters for left out samples
        out_rand(find(out == 1)) = out_rand(find(out == 1)) + 1;
        
        Xext = X(find(out == 1),:);
        class_ext = class(find(out == 1));
        Xtrain  = X(whos_in,:);
        class_train  = class(whos_in);
        
        if nargin == 8
            model = dafit(Xtrain,class_train,class_prob,method,num_comp,pret_type);
        else
            model = dafit(Xtrain,class_train,class_prob,method);
            num_comp = 0;
            pret_type = 'none';
        end
        pred = dapred(Xext,model);
        class_pred = [class_pred; pred.class_pred];
        class_true = [class_true; class_ext];
    end
    class = class_true;
    delete(hwait);
else
    class_pred = zeros(size(X,1),1);
    obj_in_block = fix(nobj/cv_groups);
    left_over = mod(nobj,cv_groups);
    st = 1;
    en = obj_in_block;
    for i = 1:cv_groups
        in = ones(size(X,1),1);
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
        Xtrain = X(find(in==1),:);
        class_train = class(find(in==1));
        Xext = X(find(in==0),:);
        class_ext = class(find(in==0));
        if nargin == 8
            model = dafit(Xtrain,class_train,class_prob,method,num_comp,pret_type);
        else
            model = dafit(Xtrain,class_train,class_prob,method);
            num_comp = 0;
            pret_type = 'none';
        end
        pred = dapred(Xext,model);
        class_pred(find(in==0)) = pred.class_pred;
    end
end

class_param = calc_class_param(class_pred,class);
cv.class_pred = class_pred;
cv.class_param = class_param;
cv.settings.cv_groups = cv_groups;
cv.settings.cv_type = cv_type;
cv.settings.class_prob = class_prob;
cv.settings.method = method;
cv.settings.num_comp = num_comp;
cv.settings.pret_type = pret_type;