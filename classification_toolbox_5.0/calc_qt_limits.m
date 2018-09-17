function [tlim,qlim] = calc_qt_limits(E,comp,nobj)

% calc Q and T2 limits of confidence for PCA and PLSDA model
% requires statistics_toolbox
% 
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
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

% T2 limit
lev_conf = 0.95;
if license('test','statistics_toolbox')
    F = finv(lev_conf,comp,nobj-comp);
    tlim = comp*(nobj - 1)/(nobj - comp)*F;
else
    tlim = NaN;
end

% Q limit
t1 = sum(E(comp+1:end).^1);
t2 = sum(E(comp+1:end).^2);
t3 = sum(E(comp+1:end).^3);
ho = 1 - (2*t1*t3)/(3*t2^2);
ca = norminv(0.95, 0, 1);
term1 = (ho*ca*(2*t2)^0.5)/t1;
term2 = (t2*ho*(ho - 1))/(t1^2);
qlim = t1*(term1 + 1 + term2)^(1/ho);