function [assigned_class,binary_assignation] = potfindclass(P,thr)

% class identification with potential functions
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

for k=1:size(P,1)
    which_class = zeros(1,size(P,2));
    for g=1:size(P,2)
        if P(k,g) > thr(g)
            which_class(g) = 1;
        end
    end
    if length(find(which_class == 1)) == 1
        assigned_class(k,1) = find(which_class == 1);
    else
        assigned_class(k,1) = 0;
    end
    binary_assignation(k,:) = which_class;
end

end
