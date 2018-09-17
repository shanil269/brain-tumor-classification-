function model = simcafit(X,class,num_comp,pret_type,assign_method)

% fit SIMCA model
%
% model = simcafit(X,class,num_comp,pret_type,assign_method)
%
% input:
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% comp              number of components for each class model [1 x classes]
% pret_type         data pretreatment 
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' for autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
% assign_method     assignation method
%                   'class modeling', samples are assigned to class(es) with normalised Q resulduals and T2 Hotelling distance lower
%                   than a class threshold. Q residuals and T2 Hotelling are normalised over their 95% confidence limits. 
%                   Samples can be predicted in none or multiple classes. Threshold is found for each class by maximizing specificity and sensitivity
%                   'dist', samples are always assigned to the closest class, i.e. the class with the lowest normalised 
%                   Q resulduals and T2 Hotelling distance. Q residuals and T2 Hotelling are normalised over their 95% confidence limits. 
%
% output:
% model structure containing
% T                 structure with scores for each class model [samples x classes] 
% Thot              structure with T2 Hotelling for each class model [samples x classes] 
% Thot_reduced      structure with normalised T2 Hotelling for each class model [samples x classes]
% Tcont             structure with T2 Hotelling contribution for each class model [samples x classes] 
% tlim              T2 Hotelling confidence limit (95th percentile) for each class model [classes x 1]
% Qres              structure with Q residuals for each class model [samples x classes] 
% Qres_reduced      structure with normalised Q residuals for each class model [samples x classes]
% Qcont             structure with Q residuals contribution for each class model [samples x classes] 
% qlim              Q residuals confidence limit (95th percentile) for each class model [classes x 1]
% modelpca          structure containing the class pca models for each class [classes x 1]
% dist              distances based on Qres_reduced and Thot_reduced [samples x classes]
% class_calc        calculated class [samples x 1]
% class_param       structure with error rate, confusion matrix, specificity, sensitivity, precision
% settings          structure with model settings
% settings.thr      when using 'class modeling' as assign_method, this field contains the distance threshold used for each class
%
% The main routine is class_gui
%
% Reference for the calculation of SIMCA distances and probabilities:
% Reference: http://wiki.eigenvector.com/index.php?title=Sample_Classification_Predictions
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Classification toolbox for MATLAB
% version 5.0 - July 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

for g=1:max(class)
    train = X(find(class==g),:);
    test = X(find(class~=g),:);
    modelpca = pca_model(train,num_comp(g),pret_type);
    modelpca = pca_project(test,modelpca);
    % scores
    T = zeros(size(modelpca.T,1),size(modelpca.T,2));
    T(find(class==g),:) = modelpca.T;
    T(find(class~=g),:) = modelpca.Tpred;
    model.T{g} = T;
    % t hotelling
    Thot = zeros(size(X,1),1);
    Thot(find(class==g),:) = modelpca.Thot';
    Thot(find(class~=g),:) = modelpca.Thot_pred';
    Tcont = zeros(size(X,1),size(X,2));
    Tcont(find(class==g),:) = modelpca.Tcont;
    Tcont(find(class~=g),:) = modelpca.Tcont_pred;
    model.Thot{g} = Thot;
    model.Thot_reduced{g} = Thot/modelpca.settings.tlim;
    model.Tcont{g} = Tcont;
    model.tlim(g) = modelpca.settings.tlim;
    % q residuals
    Qres = zeros(size(X,1),1);
    Qres(find(class==g),:) = modelpca.Qres';
    Qres(find(class~=g),:) = modelpca.Qres_pred';
    Qcont = zeros(size(X,1),size(X,2));
    Qcont(find(class==g),:) = modelpca.Qcont;
    Qcont(find(class~=g),:) = modelpca.Qcont_pred;    
    model.Qres{g} = Qres;
    model.Qres_reduced{g} = Qres./modelpca.settings.qlim;
    model.Qcont{g} = Qcont;
    model.qlim(g) = modelpca.settings.qlim;
    % pca model
    model.modelpca{g} = modelpca;
end

% calculate distance and always assign samples
for i=1:size(X,1)
    for g=1:max(class)
        Q = model.Qres_reduced{g};
        T = model.Thot_reduced{g};
        q = Q(i);
        t = T(i);
        d(i,g) = (q^2 + t^2)^0.5;
    end
    [v,c] = min(d(i,:));
    class_calc_dist(i,1) = c;
end
model.dist = d;

if strcmp(assign_method,'dist')
    model.class_calc = class_calc_dist;
    model.settings.sp(1:max(class)) = NaN;
    model.settings.sn(1:max(class)) = NaN;
    model.settings.thr(1:max(class)) = NaN;
    model.settings.thr_val(1:max(class)) = NaN;
else
    % assign samples with class modelling (d < thr)
    resthr = simcafindthr(model.dist,class);
    model.class_calc = simcafindclass(model.dist,resthr.class_thr);
    model.settings.sp = resthr.sp;
    model.settings.sn = resthr.sn;
    model.settings.thr_val = resthr.thr_val';
    model.settings.thr = resthr.class_thr;
end

model.type = 'simca';
model.class_param = calc_class_param(model.class_calc,class);
model.settings.pret_type = pret_type;
model.settings.assign_method = assign_method;
model.settings.raw_data = X;
model.settings.class = class;
model.cv = [];
model.labels.variable_labels = {};
model.labels.sample_labels = {};