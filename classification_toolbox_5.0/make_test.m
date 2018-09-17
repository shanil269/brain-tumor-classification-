function [X_train,X_test,class_train,class_test,in] = make_test(X,class,perc_in_test)

% select test set samples randomly, maintaining the class proportion
% 
% X             dataset [n x p]
% class         class vector [n x 1]
% perc_in_test  percentage of test samples to be selected, 
%               e.g. perc_in_test=0.25 to select 25% of test samples
%
% X_train       training set [n_train x p]
% class_train   training class vector [n_train x 1]
% X_test        test set [n_test x p]
% class_test    test class vector [n_test x 1]
% in            binary vector showing training/test sample positions in the
%               original dataset X. 1: training, 0: test
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

in = ones(size(X,1),1);
num_out = round(size(X,1)*perc_in_test);

for g=1:max(class)
    samples_in_class = length(find(class==g));
    perc_in_class(g) = samples_in_class/size(X,1);
    num_out_in_class(g) = round(num_out*perc_in_class(g));
end

for g=1:max(class)
    out_tot = 0;
    in_class = ones(size(X(find(class==g)),1),1);
    while out_tot < num_out_in_class(g);
        r = ceil(rand*size(X(find(class==g)),1));
        if in_class(r) == 1
            in_class(r) = 0;
            out_tot = out_tot + 1;
        end
    end
    in(find(class==g)) = in_class;
end

X_train = X(find(in==1),:);
X_test  = X(find(in==0),:);
class_train = class(find(in==1));
class_test  = class(find(in==0));

disp(['expected samples out: ' num2str(num_out)])
disp(['total samples out: ' num2str(length(find(in==0)))])
for g=1:max(class)
    disp(['class ' num2str(g) ': percentage in X ' num2str(perc_in_class(g))])
    disp(['class ' num2str(g) ': percentage in X train ' num2str(length(find(class_train==g))/size(X_train,1))])
    disp(['class ' num2str(g) ': percentage in X test  ' num2str(length(find(class_test==g))/size(X_test,1))]) 
end
