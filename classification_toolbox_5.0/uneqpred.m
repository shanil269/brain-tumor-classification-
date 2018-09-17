function pred = uneqpred(X,model)

% prediction with UNEQ
%
% pred = uneqpred(X,model)
%
% input:
% X                 dataset [samples x variables]
% model             uneq model calculated by means of uneqfit
%
% output:
% pred structure containing:
% T                 structure with scores for each class model [samples x classes] 
% Thot              matrix with T2 Hotelling for each class model [samples x classes] 
% Thot_reduced      matrix with normalised T2 Hotelling for each class model [samples x classes] 
% Tcont             structure with T2 Hotelling contribution for each class model [samples x classes]
% Qcont             structure with Q residuals contribution for each class model [samples x classes] 
% class_pred        predicted class [samples x 1]
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

for g=1:max(model.settings.class)
    modelpca = model.modelpca{g};
    modelpca = pca_project(X,modelpca);
    % scores
    pred.T{g} = modelpca.Tpred;
    % t hotelling
    pred.Thot(:,g) = modelpca.Thot_pred';
    pred.Thot_reduced(:,g) = pred.Thot(:,g)./modelpca.settings.tlim;
    pred.Tcont{g} = modelpca.Tcont_pred;
    % Q residuals
    pred.Qcont{g} = modelpca.Qcont_pred;
end

% always assign samples
for i=1:size(X,1)
    [v,c] = min(pred.Thot_reduced(i,:));
    class_pred_dist(i,1) = c;
end
[pred.class_pred,pred.settings.binary_assignation] = simcafindclass(pred.Thot_reduced,model.settings.thr);
if strcmp(model.settings.assign_method,'dist')
    pred.class_pred = class_pred_dist;
end