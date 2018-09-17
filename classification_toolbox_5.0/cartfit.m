function model = cartfit(X,class,var_labels)

% fit Classifcation Trees (CART)
%
% model = cartfit(X,class)
%
% input:            
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% optional
% var_labels        cell array with variables labels [1 x variables]
% 
% output:
% model is a structure containing
% tree              structure containing the classification tree 
% var_in_tree       retained variables in the classification tree
%                   calculated by the statistical toolbox of MATLAB
% class_calc        calculated class [samples x 1]
% class_param       classification parameters
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

if nargin < 3
    for j=1:size(X,2); var_labels{j}=['var ' num2str(j)]; end
end
t = fitctree(X,class,'PredictorNames',var_labels);
m = max(t.PruneList) - 1;
[E,~,~,best] = cvloss(t,'SubTrees',0:m,'KFold',10);
class_tree = prune(t,'Level',best);
class_calc = predict(class_tree,X);
class_param = calc_class_param(class_calc,class);

% treedisp(class_tree)
model.type = 'cart';
model.tree = class_tree;
model.class_calc = class_calc;
model.class_param = class_param;
model.settings.raw_data = X;
model.settings.class = class;
model.cv = [];
model.labels.variable_labels = {};
model.labels.sample_labels = {};
