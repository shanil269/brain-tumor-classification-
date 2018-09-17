function model = potfit(X,class,type,smoot,perc,pret_type,num_comp)

% fit class modeling Potential Functions
%
% model = potfit(X,class,type,smoot,perc,pret_type,num_comp,doplot)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% type              kernel type
%                   'gaus' gaussian kernel
%                   'tria' triangular kernel
% smoot             smoothing parameter [1 x classes], vector with
%                   smoothing parameters to be used for each class model
% perc              percentile to define the class boundary (e.g. 95)
%                   small percentiles gives smaller class spaces
% pret_type         data pretreatment 
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' for autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
% optional:
% num_comp          define the number of PCs to apply svm on Principal Components;
%                   NaN: do not apply svm on Principal Components;
%                   0: autodetect PCs by taking those components with eigenvalue higher than the average eigenvalue
%                   num_comp: integer number to define a fixed number of components to be used;
%
% output
% model is a strcture with the following fields
% P                 sample potential for each class [samples x classes]
% class_calc        calculated class [samples x 1]
% class_param       classification parameters
% settings          structure with model settings
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

for g=1:max(class)
    % potential function
    Xclass{g} = Xsca(find(class == g),:);
    for i=1:size(Xsca,1)
        P(i,g) = potcalc(Xsca(i,:),Xclass{g},type,smoot(g));
    end
    Pin = P(find(class == g),g);
    thr(g) = find_thr(Pin,perc);
end
class_calc = potfindclass(P,thr);
class_param = calc_class_param(class_calc,class);

model.type = 'pf';
model.P = P;
model.class_calc = class_calc;
model.class_param = class_param;
model.settings.thr = thr;
model.settings.smoot = smoot;
model.settings.type = type;
model.settings.perc = perc;
model.settings.Xclass = Xclass;
model.settings.num_comp = num_comp;
model.settings.pret_type = pret_type;
model.settings.param = param;
model.settings.model_pca = model_pca;
model.settings.data_scaled = Xsca;
model.settings.raw_data = X;
model.settings.class = class;
model.cv = [];
model.labels.variable_labels = {};
model.labels.sample_labels = {};

end

% ------------------------------------------------------------------
function thr = find_thr(P,perc)
% class thresholds based on percentiles
q = perc*length(P)/100;
j = fix(q);
Ssort = -sort(-P);
thr = Ssort(j) + (q - j)*(Ssort(j+1) - Ssort(j));
end