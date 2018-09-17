function pred = cartpred(X,model)

% prediction of new samples with classifcation trees (CART)
%
% pred = cartpred(X,model)
%
% input:            
% X                 dataset [samples x variables]
% model             CART model calculated by means of cartfit
%
% output:
% pred structure containing:
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

pred.class_pred = predict(model.tree,X);