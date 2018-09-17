function pred = simcapred(X,model)

% prediction with SIMCA
%
% pred = simcapred(X,model)
%
% input:
% X                 dataset [samples x variables]
% model             simca model calculated by means of simcafit
%
% output:
% pred structure containing:
% T                 structure with scores for each class model [samples x classes] 
% Thot              structure with T2 Hotelling for each class model [samples x classes] 
% Thot_reduced      structure with normalised T2 Hotelling for each class model [samples x classes] 
% Tcont             structure with T2 Hotelling contribution for each class model [samples x classes] 
% Qres              structure with Q residuals for each class model [samples x classes] 
% Qres_reduced      structure with normalised Q residuals for each class model [samples x classes] 
% Qcont             structure with Q residuals contribution for each class model [samples x classes] 
% dist              distances based on Qres_reduced and Thot_reduced [samples x classes]
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
    pred.Thot{g} = modelpca.Thot_pred';
    pred.Thot_reduced{g} = pred.Thot{g}./modelpca.settings.tlim;
    pred.Tcont{g} = modelpca.Tcont_pred;
    % q residuals
    pred.Qres{g} = modelpca.Qres_pred';
    pred.Qres_reduced{g} = pred.Qres{g}./modelpca.settings.qlim;
    pred.Qcont{g} = modelpca.Qcont_pred;
end

% always assign samples
for i=1:size(X,1)
    for g=1:max(model.settings.class)
        Q = pred.Qres_reduced{g};
        T = pred.Thot_reduced{g};
        q = Q(i);
        t = T(i);
        d(i,g) = (q^2 + t^2)^0.5;
    end
    [v,c] = min(d(i,:));
    class_pred_dist(i,1) = c;
end
pred.dist = d;
[pred.class_pred,pred.settings.binary_assignation] = simcafindclass(pred.dist,model.settings.thr);
if strcmp(model.settings.assign_method,'dist')
    pred.class_pred = class_pred_dist;
end