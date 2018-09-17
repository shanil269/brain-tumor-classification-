function res = simcafindthr(D,class)

% find optimal thresholds for normalised Q residuals and T2 Hotelling distances
% for each class (SIMCA class modeling)
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

for g=1:size(D,2)
    Dclass = D(:,g);
    class_here = 2*ones(length(class),1);
    class_here(find(class == g)) = 1;
    dspan = max(Dclass);
    dstep = dspan/100;
    cnt = 0;
    for thr=0:dstep:dspan
        cnt = cnt + 1;
        class_pred = simcafindclass(Dclass,thr);
        class_pred(find(class_pred==0)) = 2;
        cp = calc_class_param(class_pred,class_here);
        res.sp(cnt,g) = cp.specificity(1);
        res.sn(cnt,g) = cp.sensitivity(1);
        res.thr_val(cnt,g) = thr;
    end
    % find best thr where sn and sp crosses
    res.class_thr(g) = findbestthr(res.sn(:,g),res.sp(:,g),res.thr_val(:,g));
end

% -------------------------------------------------------------------
function thr = findbestthr(sn,sp,thr_val)
f = find(sn == sp);
if length(f) > 0
    % look if sn and sp are equal for a range of thr values
    % takes the intermediate
    r = round(length(f)/2);
    f = f(r);
else
    % otherwise takes first value where sn > sp
    f = find(sn > sp);
    f = f(1);
end
thr = thr_val(f);