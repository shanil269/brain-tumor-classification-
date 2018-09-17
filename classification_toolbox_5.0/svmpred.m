function pred = svmpred(X,model)

% prediction of new samples with Support Vector Machines
%
% pred = svmpred(X,model,type)
% 
% Input
% X                 data matrix  [samples x variables]
% model             model calculated by means of svmfit
%
% Output
% pred structure containing:
% class_pred        predicted class [samples x 1]
% dist              distance from class boundary [samples x 1]
%
% SVM are based on the MATLAB toolbox
% further info:
% http://it.mathworks.com/help/stats/support-vector-machines-svm.html
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

if isnan(model.settings.num_comp)
    Xsca = test_pretreatment(X,model.settings.param);
else
    [model_pca] = pca_project(X,model.settings.model_pca);
    Xsca = model_pca.Tpred;
end

[~,dist] = predict(model.settings.net,Xsca);
dist = dist(:,2);
% [~,prob] = predict(model.settings.net_scores,Xsca);
% prob = prob(:,[2 1]);

% class prediction
class_pred = sign(dist);

% put 2 instead of -1
class_pred(find(class_pred == -1)) = 2;
pred.class_pred = class_pred;
pred.dist = dist;
pred.Xsca = Xsca;
% pred.prob = prob;
