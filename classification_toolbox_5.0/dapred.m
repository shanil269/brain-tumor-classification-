function pred = dapred(X,model)

% prediction of new samples with Discriminant Analysis (DA)
%
% pred = dapred(X,model)
%
% input:
% X                 dataset [samples x variables]
% model             Discriminant Analysis model calculated by means of dafit
%
% output:
% pred structure containing:
% class_pred        predicted class [samples x 1]
% S                 scores on canonical variables [samples x G-1], only for LDA
% T                 scores on PCA if DA was calculate on principal components
% modelpca          structure with PCA model if DA was calculate on principal components
%                   the structure contains also statistics on the predicted
%                   samples (see pca_project for further info)
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

class_prob = model.settings.class_prob;
method = model.settings.method;
Xtrain = model.settings.raw_data;
num_comp = model.settings.num_comp;
class_train = model.settings.class;
nclass = max(class_train);
prob = model.settings.prob;

if num_comp > 0
    modelpca = pca_project(X,model.settings.modelpca);
    Xin = modelpca.Tpred;
    Xtrain = modelpca.T;
else
    Xin = X;
end

% if linear and not with PCs check for pooled estimate of covariance
doit = 1;
if strcmp('linear',method) & num_comp == 0
    doit = pec(Xtrain,class_train);
end

if doit
    % prediction
    if class_prob == 1
        [class_pred] = classify(Xin,Xtrain,class_train,method);
    else
        [class_pred] = classify(Xin,Xtrain,class_train,method,prob);
    end
    % prediction of scores on canonical variables only for lda
    if strcmp('linear',method)
        [a,param] = data_pretreatment(Xtrain,'cent');
        Xin_cent = test_pretreatment(Xin,param);
        pred.S = Xin_cent*model.L;
    end
else
    class_pred = ones(size(Xin,1),1);
end

pred.class_pred = class_pred;
if num_comp > 0
    pred.T = modelpca.Tpred;
    pred.modelpca = modelpca;
end

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