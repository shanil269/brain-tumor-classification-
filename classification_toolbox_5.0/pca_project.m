function [model] = pca_project(Xnew,model)

% project new samples in the defined PCA model
%
% model = pca_project(Xnew,model);
%
% input
% Xnew:             data matrix [samples x variables]
% model:            PCA model calculated by means of pca_model
%
% output
% pred structure containing:
% Tpred:            score matrix [samples x num_comp]
% Thot_pred:        T2 Hotelling [1 x samples]
% Tcont_pred:       T2 Hotelling contributions [samples x variables]
% Qres_pred:        Q residuals [1 x samples]
% Qcont_pred:       Q residuals contribution [samples x variables]
% 
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
% 
% Classification toolbox for MATLAB
% version 5.0 - July 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

X_in = test_pretreatment(Xnew,model.settings.param);
T = X_in*model.L;
model.Tpred = T;

% T2 hotelling
I = zeros(size(T,2),size(T,2)); mL = I;
for i=1:size(T,2)
    I(i,i) = model.E(i);
    mL(i,i) = 1/sqrt(model.E(i));
end
mL = mL*model.L';
for i=1:size(T,1)
    Thot(i) = T(i,:)*inv(I)*T(i,:)';
    Tcont(i,:) = T(i,:)*mL;
end
model.Thot_pred = Thot;
model.Tcont_pred = Tcont;

% Q residuals
Xmod = T*model.L';
Err = X_in - Xmod;
for i=1:size(T,1)
    Qres(i) = Err(i,:)*Err(i,:)';
end
model.Qres_pred = Qres;
model.Qcont_pred = Err;



