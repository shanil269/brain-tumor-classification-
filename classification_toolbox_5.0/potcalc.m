function p = potcalc(v,X,type,smoot)

% kernel calculation for potential functions
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

p = 0;
s = std(X);
if strcmp(type,'gaus')
    for i=1:size(X,1)
        n = 1;
        for j=1:size(X,2)
            d = (X(i,j) - v(j));
            r = smoot*s(j);
            n1 = 1/(r*(2*pi)^(1/2));
            n2 = -(d^2)/(2*(r^2));
            n = n*n1*exp(n2);
        end
        p = p + n/size(X,1);
    end
elseif strcmp(type,'tria')
    for i=1:size(X,1)
        n = norm(X(i,:) - v);
        n = n/smoot;
        if n <= 1
            n = 1 - n;
        else
            n = 0;
        end
        p = p + n;
    end
    p = p/size(X,1);
end

end

