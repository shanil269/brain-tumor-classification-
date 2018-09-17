function [assigned_class,binary_assignation] = simcafindclass(D,class_thr)

% assign samples for SIMCA (class modelling) on the basis of thresholds and normalised Q residuals and T2 Hotelling distances
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

for i=1:size(D,1)
    which_class = zeros(1,size(D,2));
    for g=1:size(D,2)
        if D(i,g) <= class_thr(g)
            which_class(g) = 1;
        end
    end
    if length(find(which_class == 1)) == 1
        assigned_class(i,1) = find(which_class == 1);
    else
        assigned_class(i,1) = 0;
    end
    binary_assignation(i,:) = which_class;
end