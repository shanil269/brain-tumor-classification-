function model = plsdafit(X,class,comp,pret_type,assign_method,doqtlimit)

% fit Partial Least Squares Discriminant Analysis (PLSDA)
%
% model = plsdafit(X,class,comp,pret_type,assign_method,doqtlimit)
%
% input:            
% X                 dataset [samples x variables]
% class             class vector [samples x 1]
% comp              number of components (latent variables)
% pret_type         data pretreatment 
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' for autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
% assign_method     assignation method
%                   'bayes' samples are assigned on thresholds based on Bayes Theorem
%                   'max' samples are assigned to the class with maximum yc
% doqtlimit         if 1 calculates T2 and Q limits
%
% output:
% model structure containing
% yc                calculated response [samples x classes]
% class_calc        calculated class [samples x 1]
% class_param       structure with error rate, confusion matrix, specificity, sensitivity, precision
% T                 X-scores [samples x comp] 
% P                 X-loadings [variables x comp] 
% W                 X-weights [classes x comp] 
% U                 Y-scores [samples x comp] 
% Q                 Y-weights [variables x comp] 
% b                 regression coefficients [variables x 1]
% expvar            explained variance on X and Y [comp x 2] 
% cumvar            cumulative explained variance on X and Y [comp x 2] 
% rmsec             root mean squared error [classes x 1] 
% H                 leverages [samples x 1] 
% Thot              T2 Hotelling [samples x 1]
% Qres              Q residuals [samples x 1]
% Tcont             T2 Hotelling contributions [samples x variables]
% Qcont             Q contributions [sampels x variables]
% settings          structure with model settings
%
% based on Frans Van Den Berg mypls routine
% http://www.models.kvl.dk/
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

x = X;
y = class;
if size(y,2) == 1
    tmp_unfold = zeros(size(x,1),max(y));
    for g=1:max(y)
        tmp_unfold(find(y==g),g) = 1;
    end
    y = tmp_unfold;
end

[xscal,px] = data_pretreatment(x,pret_type);
[yscal,py] = data_pretreatment(y,'none');

[T,P,W,U,Q,B,ssq,Ro,Rv,Lo,Lv] = mypls(xscal,yscal,comp);
yscal_c = T*Q';
Lo = Lo(:,comp);
yc = redo_scaling(yscal_c,py);
cumvar = ssq;
expvar(1,:) = cumvar(1,:);
for k=2:comp
    expvar(k,:) = cumvar(k,:) - cumvar(k - 1,:);
end

% coefficients
b = W(:,1:comp)*inv(P(:,1:comp)'*W(:,1:comp))*Q(:,1:comp)';

% T hot
fvar = sqrt(1./(diag(T'*T)/(size(x,1) - 1)));
Thot = sum((T*diag(fvar)).^2,2);
Tcont = (T*diag(fvar)*P');

% Qres
Xmod = T*P';
Qcont = xscal - Xmod;
for i=1:size(T,1)
    Qres(i) = Qcont(i,:)*Qcont(i,:)';
end

for g=1:size(y,2)
    res = calc_reg_param(y(:,g),yc(:,g));
    rmsec(g) = res.RMSEC;
end

% T2 and Q limits
if doqtlimit
    mlim = pca_model(X,comp,pret_type);
    tlim = mlim.settings.tlim;
    qlim = mlim.settings.qlim;
else
    tlim = NaN;
    qlim = NaN;
end

% class evaluation
[tmp,class_true] = max(y');
resthr = plsdafindthr(yc,class_true');
if strcmp(assign_method,'max')
    % assigns on the maximum calculated response
    [non,assigned_class] = max(yc');
else
    % assigns on the bayesian discrimination threshold
    assigned_class = plsdafindclass(yc,resthr.class_thr);
end

% class probabilities
% class assignation probabilities [samples x classes]
% calculated on the basis of http://www.eigenvector.com/faq/?id=38
% for g=1:max(class)
%     mc = mean(yc(find(class==g),g));
%     sc = std(yc(find(class==g),g));
%     mnc = mean(yc(find(class~=g),g));
%     snc = std(yc(find(class~=g),g));
%     for i=1:size(X,1)
%         Pc = 1./(sqrt(2*pi)*sc) * exp(-0.5*((yc(i,g) - mc)/sc).^2);
%         Pnc = 1./(sqrt(2*pi)*snc) * exp(-0.5*((yc(i,g) - mnc)/snc).^2);
%         Prob(i,g) = Pc/(Pc + Pnc);
%     end
% end

class_param = calc_class_param(assigned_class',class_true');
model.type = 'plsda';
model.yc = yc;
model.class_calc = assigned_class';
model.class_param = class_param;
model.T = T;
model.P = P;
model.U = U;
model.Q = Q;
model.W = W;
model.b = b;
model.cumvar = cumvar;
model.expvar = expvar;
model.rmsec = rmsec;
% model.Prob = Prob;
model.H = Lo;
model.Thot = Thot;
model.Tcont = Tcont;
model.Qres = Qres;
model.Qcont = Qcont;
model.settings.pret_type = pret_type;
model.settings.px = px;
model.settings.py = py;
model.settings.y = y;
model.settings.tlim = tlim;
model.settings.qlim = qlim;
model.settings.thr_val = resthr.thr_val';
model.settings.sp = resthr.sp;
model.settings.sn = resthr.sn;
model.settings.thr = resthr.class_thr;
model.settings.assign_method = assign_method;
model.settings.raw_data = X;
model.settings.class = class;
model.cv = [];
model.labels.variable_labels = {};
model.labels.sample_labels = {};