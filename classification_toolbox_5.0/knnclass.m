function [class_calc,class_calc_weighted,prob] = knnclass(neighbors_class,neighbors_distance,num_class)

% find a class on the basis of K neighbors
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

for g = 1:num_class
    freq(g) = length(find(neighbors_class == g));
end

unique_class = find(freq == max(freq));

if length(unique_class) == 1
    [M,class_calc] = max(freq);
else
    mean_dist = ones(num_class,1).*max(neighbors_distance);
    for g = 1:length(unique_class)
        in = find(neighbors_class == unique_class(g));
        mean_dist(unique_class(g)) = mean(neighbors_distance(in));
    end
    [m,class_calc] = min(mean_dist);
end

% weighted version
if sum(neighbors_distance) > 0
    w = ones(1,length(neighbors_distance))./(0.05 + neighbors_distance);
    w = w./sum(w);
else
    w = ones(1,length(neighbors_distance))./length(neighbors_distance);
end
u = zeros(length(neighbors_class),2);
for k=1:length(neighbors_class)
    u(k,neighbors_class(k)) = 1;
end
for k=1:length(neighbors_class)
    u(k,:) = u(k,:)*w(k);
end
if size(u,1) == 1
    [prob,class_calc_weighted] = max(u);
else
    s = sum(u);
    [prob,class_calc_weighted] = max(s);
end
