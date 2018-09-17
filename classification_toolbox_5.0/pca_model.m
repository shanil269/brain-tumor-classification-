function model = pca_model(X,num_comp,pret_type)

% fit Principal Components Analysis (PCA)
%
% [model] = pca_model(X,num_comp,pret_type);
%
% input:
% X                 dataset [samples x variables]
% num_comp          number of significant principal components
% pret_type         data pretreatment 
%                   'none' no scaling
%                   'cent' cenering
%                   'scal' variance scaling
%                   'auto' for autoscaling (centering + variance scaling)
%                   'rang' range scaling (0-1)
%
% output:
% model structure with:
% exp_var           explained variance [num_comp x 1]
% cum_var           cumulative explained variance [num_comp x 1]
% T                 score matrix [samples x num_comp]
% L                 loading matrix [variables x num_comp]
% E                 eigenvalues [num_comp x 1]
% Thot              T2 Hotelling [1 x samples]
% Tcont             T2 Hotelling contributions [samples x variables]
% Qres              Q residuals [1 x samples]
% Qcont             Q contributions [sampels x variables]
% settings          structure with model settings
% 
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Classification toolbox for MATLAB
% version 5.0 - July 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

[n,p] = size(X);
ran = min(size(X,1),size(X,2));
if num_comp > ran - 1
    num_comp = ran - 1;
end

[X_in,param] = data_pretreatment(X,pret_type);

[Tmat,E,L] = svd(X_in,0);     % diagonalisation
eigmat = E;
Efull = diag(E).^2/(n-1);      % eigenvalues
exp_var = Efull/sum(Efull);
E = Efull(1:num_comp);
exp_var = exp_var(1:num_comp);
for k=1:num_comp; cum_var(k) = sum(exp_var(1:k)); end;

L = L(:,1:num_comp);       % loadings and scores
T = X_in*L;

% T2 hotelling
I = zeros(size(T,2),size(T,2)); mL = I;
for i=1:size(T,2)
    I(i,i) = E(i);
    mL(i,i) = 1/sqrt(E(i));
end
mL = mL*L';
for i=1:size(T,1)
    Thot(i) = T(i,:)*inv(I)*T(i,:)';
    Tcont(i,:) = T(i,:)*mL;
end

% Q residuals
Xmod = T*L';
Err = X_in - Xmod;
for i=1:size(T,1)
    Qres(i) = Err(i,:)*Err(i,:)';
end

% T2 and Q limits
[tlim,qlim] = calc_qt_limits(Efull,num_comp,size(X,1));

% save results
model.type = 'pca';
model.exp_var = exp_var;
model.cum_var = cum_var';
model.E = E;
model.L = L;
model.T = T;
model.eigmat = eigmat;
model.Tmat = Tmat;
model.Qres = Qres;
model.Qcont = Err;
model.Thot = Thot;
model.Tcont = Tcont;
model.settings.tlim = tlim;
model.settings.qlim = qlim;
model.settings.Efull = Efull;
model.settings.num_comp = num_comp;
model.settings.pret_type = pret_type;
model.settings.param = param;
model.settings.ran = ran;
model.settings.raw_data = X;