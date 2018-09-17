function pred = potpred(X,model)

% prediction of new samples with class modeling Potential Functions
%
% pred = potpred(X,model,type)
%
% input:
% X                 dataset [samples x variables]
% model             potential function model calculated by means of potfit
%
% output
% pred structure containing:
% P                 sample potential for each class [samples x classes]
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

smoot = model.settings.smoot;
kernel_type = model.settings.type;
if isnan(model.settings.num_comp)
    Xsca = test_pretreatment(X,model.settings.param);
else
    [model_pca] = pca_project(X,model.settings.model_pca);
    Xsca = model_pca.Tpred;
end

for g=1:length(model.settings.Xclass)
    for i=1:size(Xsca,1)
        P(i,g) = potcalc(Xsca(i,:),model.settings.Xclass{g},kernel_type,smoot(g));
    end
end
[class_pred,binary_assignation] = potfindclass(P,model.settings.thr);
pred.P = P;
pred.class_pred =class_pred;
pred.binary_assignation = binary_assignation;
pred.Xsca = Xsca;

end

