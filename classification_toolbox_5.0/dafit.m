function model = dafit(X,class,class_prob,method,num_comp,pret_type)

% fit Discriminant Analysis (DA)
%
% model = dafit(X,class,class_prob,method,num_comp,pret_type)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% class_prob        if class_prob = 1 equal probability, if class_prob = 2 proportional prob.
% method            'linear' (LDA) or 'quadratic' (QDA)
% optional:
% num_comp          DA is calculated on the first num_comp principal components
% pret_type         scaling method when PCA is calculated
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
%
% output:
% model is a structure conyaining
% class_calc        calculated class [samples x 1]
% class_param       classification parameters
% settings          structure with model settings
% L                 loadings on canonical variables [variables x classes-1], only for LDA
% Lstd              standardized loadings on canonical variables [variables x classes-1], only for LDA
% S                 scores on canonical variables [variables x classes-1], only for LDA
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

[nobj,nvar] = size(X);
nclass = max(class);

if class_prob == 2
    for g = 1:nclass 
        obj_cla(g)  = length(find(class == g));
    end
    prob = obj_cla/nobj;
else
    prob = NaN;
end

if nargin == 6
    modelpca = pca_model(X,num_comp,pret_type);
    Xtrain = modelpca.T;
else
    Xtrain = X;
    modelpca = NaN;
    num_comp = 0;
    pret_type = 'none';
end

% if linear and not with PCs check for pooled estimate of covariance
doit = 1;
if strcmp('linear',method) & nargin < 6
    doit = pec(X,class);
end

if doit
    % fitting
    if class_prob == 1
        [class_calc] = classify(Xtrain,Xtrain,class,method);
    else
        [class_calc] = classify(Xtrain,Xtrain,class,method,prob);
    end
    % calculates canonical variables for lda
    if strcmp('linear',method)
        class_unfold = zeros(size(Xtrain,1),max(class)-1);
        for g=1:max(class)-1
            class_unfold(find(class==g),g) = 1;
        end
        [L,B,r,S,V] = canoncorr(Xtrain,class_unfold);
        for k=1:size(L,1);
            for j=1:size(L,2)
                Lstd(k,j) = L(k,j)*std(Xtrain(:,k));
            end
        end
    end
else
    class_calc = ones(size(X,1),1);
    L = zeros(size(X,2),1);
    Lstd = zeros(size(X,2),1);
    S = zeros(size(X,1),1);
end

class_param = calc_class_param(class_calc,class);
if strcmp(method,'linear')
    if num_comp > 0
        model.type = 'pcalda';
    else
        model.type = 'lda';
    end
else
    if num_comp > 0
        model.type = 'pcaqda';
    else
        model.type = 'qda';
    end
end
model.class_calc  = class_calc;
model.class_param = class_param;
if strcmp('linear',method)
    model.L = L;
    model.Lstd = Lstd;
    model.S = S;
end
model.settings.pret_type = pret_type;
model.settings.class_prob = class_prob;
model.settings.prob = prob;
model.settings.method = method;
model.settings.modelpca = modelpca;
model.settings.num_comp = num_comp;
model.settings.raw_data = X;
model.settings.class = class;
model.cv = [];
model.labels.variable_labels = {};
model.labels.sample_labels = {};

% -------------------------------------------------------------------------
function doit = pec(X,class)
for g = 1:max(class)
    gmeans(g,:) = mean(X(find(class == g),:));
end
% Pooled estimate of covariance
[Q,R] = qr(X - gmeans(class,:), 0);
R = R / sqrt(size(X,1) - max(class)); % SigmaHat = R'*R
s = svd(R);
if any(s <= eps^(3/4)*max(s))
    doit = 0;
    disp('The pooled covariance matrix of training samples must be positive definite. model not calculated');
else
    doit = 1;
end