function model = svmfit(X,class,kernel,C,kernelpar,pret_type,num_comp)

% fit Support Vector Machines (only two classes allowed)
%
% model = svmfit(X,class,kernel,C,kernelpar,pret_type,num_comp,doplot)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% kernel            type of kernel: 'linear' , 'polynomial', 'rbf'
% C                 upper bound for the coefficients alpha during training (cost)
% kernelpar         parameter for rbf and poly kernels, suggested in the range [0.01 10];
%                   for linear kernel, kernelpar can be set to []
% pret_type         data pretreatment 
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' for autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
% optional
% num_comp          define the number of PCs to apply svm on Principal Components;
%                   NaN: do not apply svm on Principal Components;
%                   0: autodetect PCs by taking those components with eigenvalue higher than the average eigenvalue
%                   num_comp: integer number to define a fixed number of components to be used;
%
% output
% model structure with
% class_calc        calculated class [samples x 1]
% class_param       classification parameters
% dist              distance from class boundary [samples x 1]
% svind             id of support vectors [sv x 1]
% alpha             alpha values [samples x 1]; 
%                   support vectors have alpha > 0
%                   suppor vectors on margin have alpha less than cost
% bias              model bias
% b                 linear coefficients [1 x variables], only for 'linear' kernel
% settings          structure with model settings
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

if nargin < 7; num_comp = NaN; end
if nargin < 8; doplot = 0; end
if max(class) > 2; 
    disp('more than two classes detected, but only two classes allowed! model wont be calculated')
    model = NaN;
    return;
end
class(find(class == 2)) = -1;
tol = 1e-2;
% pretreat data
if isnan(num_comp)
    [Xsca,param] = data_pretreatment(X,pret_type);
    model_pca = NaN;
else
    param = NaN;
    if num_comp == 0; 
        comphere = 10; 
    else
        comphere = num_comp; 
    end
    model_pca = pca_model(X,comphere,pret_type);
    if num_comp == 0;
        compin = length(find(model_pca.E > mean(model_pca.settings.Efull)));
        model_pca = pca_model(X,compin,pret_type);
    end
    Xsca = model_pca.T;
end

net = fitcsvm(Xsca,class,'KernelFunction',kernel,'KernelScale',kernelpar,'BoxConstraint',C);
[~,dist] = predict(net,Xsca);
dist = dist(:,2);
% net_scores = fitPosterior(net,Xsca,class);
% [~,prob] = predict(net_scores,Xsca);
% prob = prob(:,[2 1]);
alpha = zeros(size(X,1),1);
alpha(find(net.IsSupportVector)) = net.Alpha;
% class prediction
class_calc = sign(dist);
class(find(class == -1)) = 2;
class_calc(find(class_calc == -1)) = 2;
class_param = calc_class_param(class_calc,class);

% store linear coefficents and bias
model.type = 'svm';
model.alpha = alpha;
model.svind = find(net.IsSupportVector);
model.b = net.Beta;
model.bias = net.Bias;
model.dist = dist;
% model.prob = prob;
model.class_calc = class_calc;
model.class_param = class_param;
model.settings.net = net;
% model.settings.net_scores = net_scores;
model.settings.param = param;
model.settings.pret_type = pret_type;
model.settings.C = C;
model.settings.kernel = kernel;
model.settings.kernelpar = kernelpar;
model.settings.svind_data_scaled = Xsca(model.svind,:);
model.settings.svind_data = X(model.svind,:);
model.settings.data_scaled = Xsca;
model.settings.num_comp = num_comp;
model.settings.model_pca = model_pca;
model.settings.raw_data = X;
model.settings.class = class;
model.cv = [];
model.labels.variable_labels = {};
model.labels.sample_labels = {};