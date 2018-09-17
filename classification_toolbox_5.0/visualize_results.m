function varargout = visualize_results(varargin)

% visualize_results opens a graphical interface for analysing classification results 
%
% This routine is used in the graphical user interface of the toolbox
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Classification toolbox for MATLAB
% version 5.0 - July 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_results_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_results_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before visualize_results is made visible.
function visualize_results_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 9.6471 140.5714 55.8235]);
set(handles.visualize_results,'Position',[103.8571 9.6471 140.5714 55.8235]);

set(handles.hull_chk,'Position',[3.8 41.0814 20.4 1.1538]);
set(handles.legend_chk,'Position',[3.8 42.8507 16.6 1.1538]);
set(handles.y_pop_variable,'Position',[3.8 19.1584 22 1.769]);
set(handles.x_pop_variable,'Position',[3.8 22.8507 22 1.769]);
set(handles.text15,'Position',[3.8 24.3122 10 1.2308]);
set(handles.text14,'Position',[3.8 20.6968 10.2 1.2308]);
set(handles.var_lab_chk,'Position',[3.8 16.8507 19.6 1.3846]);
set(handles.text13,'Position',[3.4 26.0045 21.4 1.1538]);
set(handles.view_sample_button,'Position',[4 34.4661 21.8 1.7692]);
set(handles.pca_title_text,'Position',[3.4 53.6199 12.8 1.1538]);
set(handles.sample_lab_chk,'Position',[3.8 44.6199 16.9 1.1538]);
set(handles.loading_title_text,'Position',[39.8 26.543 90.2 1.1538]);
set(handles.score_title_text,'Position',[40.2 54.0814 90.4 1.1538]);
set(handles.open_variable_button,'Position',[4.4 14.3122 21.8 1.9231]);
set(handles.open_sample_button,'Position',[4 31.6968 22 1.8462]);
set(handles.text16,'Position',[3.8 39.3 15 1.2308]);
set(handles.pop_classpotential,'Position',[4 37.7 22 1.769]);
set(handles.y_pop_sample,'Position',[3.8 46.6968 22 1.769]);
set(handles.x_pop_sample,'Position',[3.8 50.3891 22 1.769]);
set(handles.text3,'Position',[3.8 51.9276 10 1.2308]);
set(handles.text4,'Position',[3.8 48.3122 10.2 1.2308]);
set(handles.frame_pca,'Position',[2 31.0045 25.8 22.9231]);
set(handles.frame6,'Position',[2 13.0045 26 13.3077]);
set(handles.variable_plot,'Position',[41.8 4.3891 95.2 22]);
set(handles.sample_plot,'Position',[41.8 31.9276 95.2 22]);

set(handles.output,'Position',[103.8571 9.6471 140.5714 55.8235]);
movegui(handles.visualize_results,'center');
handles.model = varargin{1};
handles.pred = varargin{2};
if length(varargin) > 2
    handles.showspecificmodel = varargin{3};
else
    handles.showspecificmodel = 'none';
end

% set x and y combo for samples
handles = set_sample_combo(handles);

% set x and y combo for variables
handles = set_variable_combo(handles);

% set class potential combo
str_disp{1} = 'none';
for g=1:max(handles.model.settings.class)
    str_disp{g+1} = ['class ' num2str(g)];
end
set(handles.pop_classpotential,'String',str_disp);
set(handles.pop_classpotential,'Value',1);

if length(handles.model.settings.class) == 0
    set(handles.legend_chk,'Enable','off');
    set(handles.legend_chk,'Value',0);
else
    set(handles.legend_chk,'Enable','on');
    set(handles.legend_chk,'Value',1);
end

% enable/disable combo
handles = enable_disable(handles);

update_plot_samples(handles,0);
update_plot_variables(handles,0);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_results_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function x_pop_sample_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in x_pop_sample.
function x_pop_sample_Callback(hObject, eventdata, handles)
handles = enable_disable(handles);
update_plot_samples(handles,0)

% --- Executes during object creation, after setting all properties.
function y_pop_sample_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in y_pop_sample.
function y_pop_sample_Callback(hObject, eventdata, handles)
handles = enable_disable(handles);
update_plot_samples(handles,0)

% --- Executes during object creation, after setting all properties.
function x_pop_variable_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in x_pop_variable.
function x_pop_variable_Callback(hObject, eventdata, handles)
update_plot_variables(handles,0);

% --- Executes during object creation, after setting all properties.
function y_pop_variable_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_classpotential.
function pop_classpotential_Callback(hObject, eventdata, handles)
update_plot_samples(handles,0)

% --- Executes during object creation, after setting all properties.
function pop_classpotential_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in y_pop_variable.
function y_pop_variable_Callback(hObject, eventdata, handles)
update_plot_variables(handles,0);

% --- Executes on button press in open_sample_button.
function open_sample_button_Callback(hObject, eventdata, handles)
update_plot_samples(handles,1)

% --- Executes on button press in open_variable_button.
function open_variable_button_Callback(hObject, eventdata, handles)
update_plot_variables(handles,1);

% --- Executes on button press in sample_lab_chk.
function sample_lab_chk_Callback(hObject, eventdata, handles)
update_plot_samples(handles,0)

% --- Executes on button press in legend_chk.
function legend_chk_Callback(hObject, eventdata, handles)
update_plot_samples(handles,0);

% --- Executes on button press in hull_chk.
function hull_chk_Callback(hObject, eventdata, handles)
update_plot_samples(handles,0);

% --- Executes on button press in var_lab_chk.
function var_lab_chk_Callback(hObject, eventdata, handles)
update_plot_variables(handles,0);

% --- Executes on button press in view_sample_button.
function view_sample_button_Callback(hObject, eventdata, handles)
select_sample(handles)

% ------------------------------------------------------------------------
function handles = enable_disable(handles)
x = get(handles.x_pop_sample, 'Value');
y = get(handles.y_pop_sample, 'Value');
[Tx,Lab_Tx] = find_what_to_plot_sample(handles,x);
[Ty,Lab_Ty] = find_what_to_plot_sample(handles,y);
there_x = findstr(Lab_Tx,'samples');
there_y = findstr(Lab_Ty,'samples');
if length(there_x) > 0 || length(there_y) > 0
    set(handles.pop_classpotential,'Value',1);
    set(handles.pop_classpotential,'Enable','off');
    set(handles.hull_chk,'Value',0);
    set(handles.hull_chk,'Enable','off');
else
    set(handles.pop_classpotential,'Enable','on');
    set(handles.hull_chk,'Enable','on');
end

% ---------------------------------------------------------
function update_plot_samples(handles,external)

col_ass = visualize_colors;

% settings
X = handles.model.settings.raw_data;
if isstruct(handles.model.cv)
    docv = 1;
else
    docv = 0;
end
    
if length(handles.model.labels.sample_labels) > 0
    sample_labels = handles.model.labels.sample_labels;
else
    for k=1:size(X,1); sample_labels{k} = num2str(k); end
end

label_sample   = get(handles.sample_lab_chk, 'Value');
show_legend    = get(handles.legend_chk, 'Value');
show_hull      = get(handles.hull_chk, 'Value');
show_potential = get(handles.pop_classpotential, 'Value');

x = get(handles.x_pop_sample, 'Value');
y = get(handles.y_pop_sample, 'Value');

[Tx,Lab_Tx,Tx_pred] = find_what_to_plot_sample(handles,x);
[Ty,Lab_Ty,Ty_pred] = find_what_to_plot_sample(handles,y);

class_for_plot = handles.model.settings.class;

% set figure
if external; figure; title('sample plot'); set(gcf,'color','white'); else; axes(handles.sample_plot); end
cla;
hold on

% display class potential
if show_potential > 1
    [P,xx,yy,step_potential,LineStyle,LineColor,LineWidth,map] = calculate_classpotential([Tx Ty],class_for_plot,show_potential - 1);
    contourf(xx, yy, P, step_potential,'LineStyle',LineStyle,'LineColor',LineColor,'LineWidth',LineWidth)
    colormap(map)
    set(gca,'layer','top') % to have box on
end

% display samples
for g=1:max(class_for_plot)
    color_in = col_ass(g+1,:);
    plegend(g) = plot(Tx(find(class_for_plot==g)),Ty(find(class_for_plot==g)),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',color_in);
    legend_label{g} = ['class ' num2str(g)];
end
% display convex hull
for g=1:max(class_for_plot)
    color_in = col_ass(g+1,:);
    if show_hull
        xhull = Tx(find(class_for_plot==g));
        yhull = Ty(find(class_for_plot==g));
        k = convhull(xhull,yhull);
        plot(xhull(k),yhull(k),'Color',color_in)
    end
end

% plot predicted samples
if length(Tx_pred) > 0 & length(Ty_pred) > 0
    if isfield(handles.pred,'class')
        class_test_for_plot = handles.pred.class;
        for g=1:max(class_test_for_plot)
            color_in = col_ass(g+1,:);
            plot(Tx_pred(find(class_test_for_plot==g)),Ty_pred(find(class_test_for_plot==g)),'*','MarkerEdgeColor',color_in,'MarkerSize',5,'MarkerFaceColor',color_in)
            legend_label{g} = ['class ' num2str(g)];
        end
    else
        plot(Tx_pred,Ty_pred,'*','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor','k')
    end
    range_plot_x = [Tx;Tx_pred];
    range_plot_y = [Ty;Ty_pred];
    if label_sample
        range_span = (max(range_plot_x) - min(range_plot_x));
        plot_string_label(Tx_pred,Ty_pred,'r',handles.pred.sample_labels,range_span);
    end
else
    range_plot_x = Tx;
    range_plot_y = Ty;
end

% add labels
if label_sample;
    range_span = (max(range_plot_x) - min(range_plot_x));
    plot_string_label(Tx,Ty,'k',sample_labels,range_span);
end

% set max and min for axis
range_x = max(range_plot_x) - min(range_plot_x); add_space_x = range_x/20;      
x_lim = [min(range_plot_x)-add_space_x max(range_plot_x)+add_space_x];
range_y = max(range_plot_y) - min(range_plot_y); add_space_y = range_y/20;      
y_lim = [min(range_plot_y)-add_space_y max(range_plot_y)+add_space_y];
qhere_x = findstr(Lab_Tx,'Q residuals');
there_x = findstr(Lab_Tx,'Hotelling T^2');
qhere_y = findstr(Lab_Ty,'Q residuals');
there_y = findstr(Lab_Ty,'Hotelling T^2');
if strcmp(Lab_Tx,'samples')
    range_x = size(X,1) + length(Tx_pred) - 1; add_space_x = range_x/20;      
    x_lim = [1-add_space_x (size(X,1) + length(Tx_pred))+add_space_x];       
elseif strcmp(Lab_Tx,'leverages')
    this = find_max_axis(x_lim(2),3*mean(handles.model.H));
    x_lim = [0 this];
elseif strcmp(Lab_Tx,'Q residuals')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        qlim = handles.model.settings.modelpca.settings.qlim;
    else
        qlim = handles.model.settings.qlim;
    end
    if ~isnan(qlim); this = find_max_axis(x_lim(2),qlim); x_lim = [x_lim(1) this]; end
elseif length(qhere_x) > 0
    c = str2num(Lab_Tx(7));
    qlim = handles.model.qlim(c);
    if ~isnan(qlim); this = find_max_axis(x_lim(2),qlim); x_lim = [x_lim(1) this]; end
elseif strcmp(Lab_Tx,'Hotelling T^2')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        tlim = handles.model.settings.modelpca.settings.tlim;
    else
        tlim = handles.model.settings.tlim;
    end
    if ~isnan(tlim); this = find_max_axis(x_lim(2),tlim); x_lim = [x_lim(1) this]; end
elseif length(there_x) > 0 && strcmp(handles.model.type,'uneq')
    c = str2num(Lab_Tx(7));
    tlim = handles.model.settings.thr(c);
    if ~isnan(tlim); this = find_max_axis(x_lim(2),tlim); x_lim = [x_lim(1) this]; end
elseif length(there_x) > 0
    c = str2num(Lab_Tx(7));
    tlim = handles.model.tlim(c);
    if ~isnan(tlim); this = find_max_axis(x_lim(2),tlim); x_lim = [x_lim(1) this]; end
end
if strcmp(Lab_Ty,'samples')
    range_y = size(X,1) + length(Ty_pred) - 1; add_space_y = range_y/20;      
    y_lim = [1-add_space_y (size(X,1) + length(Tx_pred))+add_space_y]; 
elseif strcmp(Lab_Ty,'leverages')
    this = find_max_axis(y_lim(2),3*mean(handles.model.H));
    y_lim = [0 this];
elseif strcmp(Lab_Ty,'Q residuals')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        qlim = handles.model.settings.modelpca.settings.qlim;
    else
        qlim = handles.model.settings.qlim;
    end
    if ~isnan(qlim); this = find_max_axis(y_lim(2),qlim); y_lim = [y_lim(1) this]; end
elseif length(qhere_y) > 0
    c = str2num(Lab_Ty(7));
    qlim = handles.model.qlim(c);
    if ~isnan(qlim); this = find_max_axis(y_lim(2),qlim); y_lim = [y_lim(1) this]; end
elseif strcmp(Lab_Ty,'Hotelling T^2')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        tlim = handles.model.settings.modelpca.settings.tlim;
    else
        tlim = handles.model.settings.tlim;
    end
    if ~isnan(tlim); this = find_max_axis(y_lim(2),tlim); y_lim = [y_lim(1) this]; end    
elseif length(there_y) > 0 && strcmp(handles.model.type,'uneq')
    c = str2num(Lab_Ty(7));
    tlim = handles.model.settings.thr(c);
    if ~isnan(tlim); this = find_max_axis(y_lim(2),tlim); y_lim = [y_lim(1) this]; end
elseif length(there_y) > 0
    c = str2num(Lab_Ty(7));
    tlim = handles.model.tlim(c);
    if ~isnan(tlim); this = find_max_axis(y_lim(2),tlim); y_lim = [y_lim(1) this]; end
end

% draw lines
if strcmp(Lab_Tx,'leverages')
    line([3*mean(handles.model.H) 3*mean(handles.model.H)],y_lim,'Color','r','LineStyle',':')
elseif strncmp(Lab_Tx,'calculated response',19) & strcmp(handles.model.settings.assign_method,'bayes')
    classin = x - 1;
    thrc = handles.model.settings.thr(classin);
    line([thrc thrc],y_lim,'Color','r','LineStyle',':')
elseif strncmp(Lab_Tx,'cross validated response',24)
    classin = x - 1 - max(handles.model.settings.class);
    thrc = handles.model.settings.thr(classin);
    line([thrc thrc],y_lim,'Color','r','LineStyle',':')
elseif strncmp(Lab_Tx,'potential',9)
    classin = x - 1;
    thrc = handles.model.settings.thr(classin);
    line([thrc thrc],y_lim,'Color','r','LineStyle',':')    
elseif length(strfind(Lab_Tx,'scores')) > 0
    line([0 0],y_lim,'Color','k','LineStyle',':')
elseif strcmp(Lab_Tx,'Q residuals')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        qlim = handles.model.settings.modelpca.settings.qlim;
    else
        qlim = handles.model.settings.qlim;
    end
    if ~isnan(qlim); line([qlim qlim],y_lim,'Color','r','LineStyle',':'); end
elseif length(qhere_x) > 0
    c = str2num(Lab_Tx(7));
    qlim = handles.model.qlim(c);
    if ~isnan(qlim); line([qlim qlim],y_lim,'Color','r','LineStyle',':'); end
elseif strcmp(Lab_Tx,'Hotelling T^2')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        tlim = handles.model.settings.modelpca.settings.tlim;
    else
        tlim = handles.model.settings.tlim;
    end
    if ~isnan(tlim); line([tlim tlim],y_lim,'Color','r','LineStyle',':'); end
elseif length(there_x) > 0 && strcmp(handles.model.type,'uneq')
    c = str2num(Lab_Tx(7));
    tlim = handles.model.settings.thr(c);
    if ~isnan(tlim); line([tlim tlim],y_lim,'Color','r','LineStyle',':'); end
elseif length(there_x) > 0
    c = str2num(Lab_Tx(7));
    tlim = handles.model.tlim(c);
    if ~isnan(tlim); line([tlim tlim],y_lim,'Color','r','LineStyle',':'); end
elseif length(strfind(Lab_Tx,'distance')) > 0
    which_class = find_class_with_label_single(Lab_Tx);
    if ~strcmp(handles.model.type,'svm')
        if ~isnan(handles.model.settings.thr(1))
            dlim = handles.model.settings.thr(which_class);
            line([dlim dlim],y_lim,'Color','r','LineStyle',':');
        end
    else
        line([-1 -1],y_lim,'Color','k','LineStyle',':');
        line([0 0],y_lim,'Color','r','LineStyle',':');
        line([1 1],y_lim,'Color','k','LineStyle',':');
    end
end
if strcmp(Lab_Ty,'leverages')
    line(x_lim,[3*mean(handles.model.H) 3*mean(handles.model.H)],'Color','r','LineStyle',':')
elseif strncmp(Lab_Ty,'calculated response',19) & strcmp(handles.model.settings.assign_method,'bayes')
    classin = y - 1;
    thrc = handles.model.settings.thr(classin);
    line(x_lim,[thrc thrc],'Color','r','LineStyle',':')
elseif strncmp(Lab_Ty,'cross validated response',24)
    classin = y - 1 - max(handles.model.settings.class);
    thrc = handles.model.settings.thr(classin);
    line(x_lim,[thrc thrc],'Color','r','LineStyle',':')    
elseif strncmp(Lab_Ty,'potential',9)
    classin = y - 1;
    thrc = handles.model.settings.thr(classin);
    line(x_lim,[thrc thrc],'Color','r','LineStyle',':')    
elseif length(strfind(Lab_Ty,'scores')) > 0
    line(x_lim,[0 0],'Color','k','LineStyle',':')
elseif strcmp(Lab_Ty,'Q residuals')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        qlim = handles.model.settings.modelpca.settings.qlim;
    else
        qlim = handles.model.settings.qlim;
    end
    if ~isnan(qlim); line(x_lim,[qlim qlim],'Color','r','LineStyle',':'); end
elseif length(qhere_y) > 0
    c = str2num(Lab_Ty(7));
    qlim = handles.model.qlim(c);
    if ~isnan(qlim); line(x_lim,[qlim qlim],'Color','r','LineStyle',':'); end
elseif strcmp(Lab_Ty,'Hotelling T^2')
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        tlim = handles.model.settings.modelpca.settings.tlim;
    else
        tlim = handles.model.settings.tlim;
    end
    if ~isnan(tlim); line(x_lim,[tlim tlim],'Color','r','LineStyle',':'); end
elseif length(there_y) > 0 && strcmp(handles.model.type,'uneq')
    c = str2num(Lab_Ty(7));
    tlim = handles.model.settings.thr(c);
    if ~isnan(tlim); line(x_lim,[tlim tlim],'Color','r','LineStyle',':'); end
elseif length(there_y) > 0
    c = str2num(Lab_Ty(7));
    tlim = handles.model.tlim(c);
    if ~isnan(tlim); line(x_lim,[tlim tlim],'Color','r','LineStyle',':'); end
elseif length(strfind(Lab_Ty,'distance')) > 0
    which_class = find_class_with_label_single(Lab_Ty);
    if ~strcmp(handles.model.type,'svm')
        if ~isnan(handles.model.settings.thr(1))
            dlim = handles.model.settings.thr(which_class);
            line(x_lim,[dlim dlim],'Color','r','LineStyle',':');
        end
    else
        line(x_lim,[-1 -1],'Color','k','LineStyle',':');
        line(x_lim,[0 0],'Color','r','LineStyle',':');
        line(x_lim,[1 1],'Color','k','LineStyle',':');
    end
end

axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
xlabel(Lab_Tx)
ylabel(Lab_Ty)
if show_legend == 1
    legend(plegend,legend_label);
else
    legend off
end
box on; 
hold off

% ---------------------------------------------------------
function update_plot_variables(handles,external)

label_variable = get(handles.var_lab_chk, 'Value');

if length(handles.model.labels.variable_labels) > 0
    if strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
        if strcmp(handles.showspecificmodel,'pca') % set labels for loading plot
            variable_labels = handles.model.labels.variable_labels;
        else % set labels for canonical coefficients
            for k=1:size(handles.model.settings.modelpca.L,2); variable_labels{k} = ['PC ' num2str(k)]; end
        end
    else
        variable_labels = handles.model.labels.variable_labels;
    end
else
    for k=1:size(handles.model.settings.raw_data,2); variable_labels{k} = num2str(k); end
end

x = get(handles.x_pop_variable, 'Value');
y = get(handles.y_pop_variable, 'Value');

[Tx,Lab_Tx] = find_what_to_plot_variable(handles,x);
[Ty,Lab_Ty] = find_what_to_plot_variable(handles,y);

% display variables
if external; figure; title('variable plot'); set(gcf,'color','white'); box on; else; axes(handles.variable_plot); end

cla reset;
hold on
if length(Tx) > 0 && length(Ty) > 0
    if strcmp(Lab_Tx,'variables')
        if length(Ty) < 20
            bar(Ty,'r')
        else
            plot(Ty,'r')
        end
    elseif strcmp(Lab_Ty,'variables')
        barh(Tx,'r')
    else
        plot(Tx,Ty,'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor','r')
    end
    xlabel(Lab_Tx)
    ylabel(Lab_Ty)

    if strcmp(Lab_Tx,'variables')
        range_span_y = (max(Ty) - min(Ty));
        if min(Ty) > 0 & (strcmp(Lab_Ty,'coefficients') | strcmp(Lab_Ty,'stand. coefficients'))
            y_lim(1) = 0;
            y_lim(2) = max(Ty) + max(Ty)/10;
        elseif max(Ty) < 0 & (strcmp(Lab_Ty,'coefficients') | strcmp(Lab_Ty,'stand. coefficients'))
            y_lim(2) = 0;
            y_lim(1) = min(Ty) - min(Ty)/10;
        else
            y_lim(1) = min(Ty) - range_span_y/10;
            y_lim(2) = max(Ty) + range_span_y/10;
        end
        x_lim = [0.5 length(Ty)+0.5];
        axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
        if length(Ty) < 20
            set(gca,'XTick',[1:length(Ty)])
            set(gca,'XTickLabel',variable_labels)
        end
    elseif strcmp(Lab_Ty,'variables')
        range_span_x = (max(Tx) - min(Tx));
        if min(Tx) > 0
            x_lim(1) = 0;
            x_lim(2) = max(Tx) + max(Tx)/10;
        elseif max(Tx) < 0
            x_lim(2) = 0;
            x_lim(1) = min(Tx) - min(Tx)/10;
        else
            x_lim(1) = min(Tx) - range_span_x/10;
            x_lim(2) = max(Tx) + range_span_x/10;
        end
        y_lim = [0.5 length(Ty)+0.5];
        axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
        if length(Tx) < 20
            set(gca,'YTick',[1:length(Tx)])
            set(gca,'YTickLabel',variable_labels)
        end
    else
        range_span_x = (max(Tx) - min(Tx));
        range_span_y = (max(Ty) - min(Ty));
        y_lim(1) = min(Ty) - range_span_y/10; y_lim(2) = max(Ty) + range_span_y/10;
        x_lim(1) = min(Tx) - range_span_x/10; x_lim(2) = max(Tx) + range_span_x/10;
        axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
    end
    line(x_lim,[0 0],'Color','k','LineStyle',':')
    line([0 0],y_lim,'Color','k','LineStyle',':')
    if (label_variable & ~strcmp(Lab_Ty,'variables')) & (label_variable & ~strcmp(Lab_Tx,'variables'))
        range_span = (x_lim(2) - x_lim(1));
        plot_string_label(Tx,Ty,'k',variable_labels,range_span);
    end
else
    text(0.4,0.5,'no available results')
end

box on
hold off

% ---------------------------------------------------------
function this = find_max_axis(x1,x2)
m = max([x1 x2]);
this = m + m/20;

% ---------------------------------------------------------
function plot_string_label(X,Y,col,lab,range_span)

add_span = range_span/100;
for j=1:length(X); text(X(j)+add_span,Y(j),lab{j},'Color',col); end;

% ---------------------------------------------------------
function select_sample(handles)
    
if length(handles.model.labels.sample_labels) > 0
    sample_labels = handles.model.labels.sample_labels;
    if isstruct (handles.pred)
        if size(sample_labels,2)> size(sample_labels,1); sample_labels = sample_labels'; end
        sample_labels = [sample_labels;handles.pred.sample_labels];
    end
else
    for k=1:size(handles.model.settings.raw_data,1); sample_labels{k} = num2str(k); end
    if isstruct (handles.pred)
        if size(sample_labels,2)> size(sample_labels,1); sample_labels = sample_labels'; end
        sample_labels = [sample_labels;handles.pred.sample_labels];
    end
end
if length(handles.model.labels.variable_labels) > 0
    variable_labels = handles.model.labels.variable_labels;
else
    for k=1:size(handles.model.settings.raw_data,2); variable_labels{k} = num2str(k); end
end

x = get(handles.x_pop_sample, 'Value');
y = get(handles.y_pop_sample, 'Value');

[Tx,Lab_Tx,Tx_pred] = find_what_to_plot_sample(handles,x);
[Ty,Lab_Ty,Ty_pred] = find_what_to_plot_sample(handles,y);

if size(Tx,1) < size(Tx,2); Tx = Tx'; end
if size(Tx_pred,1) < size(Tx_pred,2); Tx_pred = Tx_pred'; end

if length(Tx_pred)==length(Ty_pred)
    Tx = [Tx;Tx_pred];
    Ty = [Ty;Ty_pred];
end
if size(Ty,2) > size(Ty,1); Ty=Ty'; end
if size(Tx,2) > size(Tx,1); Tx=Tx'; end
Xd = [Tx Ty];
[x_sel,y_sel] = ginput(1);
xd = [x_sel y_sel];
D_squares_x = (sum(xd'.^2))'*ones(1,size(Xd,1));
D_squares_w = sum(Xd'.^2);
D_product   = - 2*(xd*Xd');
D = (D_squares_x + D_squares_w + D_product).^0.5;
[d_min,closest] = min(D);

update_plot_samples(handles,0)
axes(handles.sample_plot);
hold on
plot(Tx(closest),Ty(closest),'o','MarkerEdgeColor','r','MarkerSize',8)
plot(Tx(closest),Ty(closest),'o','MarkerEdgeColor','r','MarkerSize',11)
hold off
str = get(legend,'String');
str = str(1:end-2);
set(legend,'String',str);

% find data
if isstruct (handles.pred)
    raw_data = [handles.model.settings.raw_data;handles.pred.X];
else
    raw_data = handles.model.settings.raw_data;    
end

datain = raw_data(closest,:);
if isfield(handles.model.settings,'px')
    datain_scal = test_pretreatment(datain,handles.model.settings.px);
else
    [xsc,param] = data_pretreatment(raw_data,'auto');
    datain_scal = test_pretreatment(datain,param);
end

if (strcmp(handles.model.type,'pf') || strcmp(handles.model.type,'svm') || strcmp(handles.model.type,'lda') || strcmp(handles.model.type,'pcalda')) && strcmp(handles.showspecificmodel,'none')
    figure
    subplot(2,1,1)
    hold on
    inplot = datain_scal;
    plot(inplot,'k')
    if length(inplot) < 20
        plot(inplot,'o','MarkerEdgeColor','k','MarkerSize',6,'MarkerFaceColor','r')
    end
    hold off
    range_y = max(max(inplot)) - min(min(inplot));
    add_space_y = range_y/20;
    y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
    axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
    if length(inplot) < 20
        set(gca,'XTick',[1:length(inplot)])
        set(gca,'XTickLabel',variable_labels)
    end
    % xlabel('variables')
    title(['variable profile of sample ' sample_labels{closest} ' - scaled data'])
    set(gcf,'color','white')
    box on
    
    subplot(2,1,2)
    hold on
    inplot = datain;
    plot(inplot,'k')
    if length(inplot) < 20
        plot(inplot,'o','MarkerEdgeColor','k','MarkerSize',6,'MarkerFaceColor','r')
    end
    hold off
    range_y = max(max(inplot)) - min(min(inplot));
    add_space_y = range_y/20;
    y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
    axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
    if length(inplot) < 20
        set(gca,'XTick',[1:length(inplot)])
        set(gca,'XTickLabel',variable_labels)
    end
    if ~strcmp(handles.model.type,'plsda')
        xlabel('variables')
    end
    title(['variable profile of sample ' sample_labels{closest} ' - raw data'])
    set(gcf,'color','white')
    box on
else % PLSDA, SIMCA, PCA, UNEQ
    figure
    subplot(2,2,1)
    hold on
    inplot = datain_scal;
    plot(inplot,'k')
    if length(inplot) < 20
        plot(inplot,'o','MarkerEdgeColor','k','MarkerSize',6,'MarkerFaceColor','r')
    end
    hold off
    range_y = max(max(inplot)) - min(min(inplot));
    add_space_y = range_y/20;
    y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
    axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
    if length(inplot) < 20
        set(gca,'XTick',[1:length(inplot)])
        set(gca,'XTickLabel',variable_labels)
    end
    % xlabel('variables')
    title(['variable profile of sample ' sample_labels{closest} ' - scaled data'])
    set(gcf,'color','white')
    box on
    
    subplot(2,2,3)
    hold on
    inplot = datain;
    plot(inplot,'k')
    if length(inplot) < 20
        plot(inplot,'o','MarkerEdgeColor','k','MarkerSize',6,'MarkerFaceColor','r')
    end
    hold off
    range_y = max(max(inplot)) - min(min(inplot));
    add_space_y = range_y/20;
    y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
    axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
    if length(inplot) < 20
        set(gca,'XTick',[1:length(inplot)])
        set(gca,'XTickLabel',variable_labels)
    end
    if ~strcmp(handles.model.type,'plsda')
        xlabel('variables')
    end
    title(['variable profile of sample ' sample_labels{closest} ' - raw data'])
    set(gcf,'color','white')
    box on
    
    subplot(2,2,2)
    hold on
    box on
    set(gcf,'color','white')
    if isstruct(handles.pred)
        if strcmp(handles.model.type,'plsda')
            Tcont_all = [handles.model.Tcont; handles.pred.Tcont];
        elseif strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
            Tcont_all = [handles.model.settings.modelpca.Tcont; handles.pred.modelpca.Tcont_pred];         
        elseif strcmp(handles.model.type,'simca') || strcmp(handles.model.type,'uneq')
            which_class = find_class_with_labels(Lab_Tx,Lab_Ty);
            Tcont_all = [handles.model.Tcont{which_class}; handles.pred.Tcont{which_class}];
        end
        inplot = Tcont_all(closest,:);
    else
        if strcmp(handles.model.type,'plsda')
            inplot = handles.model.Tcont(closest,:);
        elseif strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
            inplot = handles.model.settings.modelpca.Tcont(closest,:);
        elseif strcmp(handles.model.type,'simca') || strcmp(handles.model.type,'uneq')
            which_class = find_class_with_labels(Lab_Tx,Lab_Ty);
            inplot = handles.model.Tcont{which_class}(closest,:);
        end
    end
    bar(inplot,'k')
    if length(inplot) < 20
        set(gca,'XTick',[1:length(inplot)])
        set(gca,'XTickLabel',variable_labels)
    end
    xlabel('variables')
    if strcmp(handles.model.type,'simca')
        title(['Hotelling T^2 contributions (PCA model of class ' num2str(which_class) ') of sample ' sample_labels{closest}])
    else
        title(['Hotelling T^2 contributions of sample ' sample_labels{closest}])
    end
    range_y = max(inplot) - min(inplot);
    add_space_y = range_y/20;
    y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
    axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
    hold off
    
    subplot(2,2,4)
    hold on
    box on
    set(gcf,'color','white')
    if isstruct(handles.pred)
        if strcmp(handles.model.type,'plsda')
            Qcont_all = [handles.model.Qcont; handles.pred.Qcont];
        elseif strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
            Qcont_all = [handles.model.settings.modelpca.Qcont; handles.pred.modelpca.Qcont_pred];
        elseif strcmp(handles.model.type,'simca') || strcmp(handles.model.type,'uneq')
            which_class = find_class_with_labels(Lab_Tx,Lab_Ty);
            Qcont_all = [handles.model.Qcont{which_class}; handles.pred.Qcont{which_class}];
        end
        inplot = Qcont_all(closest,:);
    else
        if strcmp(handles.model.type,'plsda')
            inplot = handles.model.Qcont(closest,:);
        elseif strcmp(handles.model.type,'pcalda') || strcmp(handles.model.type,'pcaqda')
            inplot = handles.model.settings.modelpca.Qcont(closest,:);
        elseif strcmp(handles.model.type,'simca') || strcmp(handles.model.type,'uneq')
            which_class = find_class_with_labels(Lab_Tx,Lab_Ty);
            inplot = handles.model.Qcont{which_class}(closest,:);
        end
    end
    bar(inplot,'k')
    if length(inplot) < 20
        set(gca,'XTick',[1:length(inplot)])
        set(gca,'XTickLabel',variable_labels)
    end
    xlabel('variables')
    if strcmp(handles.model.type,'simca')
        title(['Q contributions (scaled - calc in PCA model of class ' num2str(which_class) ') of sample ' sample_labels{closest}])
    else
        title(['Q contributions (scaled - calc) of sample ' sample_labels{closest}])
    end
    range_y = max(inplot) - min(inplot);
    add_space_y = range_y/20;
    y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
    axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
    hold off
end

% -------------------------------------------------------------------
function [P,xx,yy,step_potential,LineStyle,LineColor,LineWidth,map] = calculate_classpotential(X,class,which_class)
step_grid = 50;
step_potential = 20;
col_ass = visualize_colors;
smoot = 0.5*ones(1,max(class));
LineStyle = 'none';
LineWidth = 0.2;
LineColor = [0.9 0.9 0.9];

[x,y,Xgrid] = makegriddata(X,step_grid);
model = potfit(X,class,'gaus',smoot,95,'none');
pred = potpred(Xgrid,model);
P = reshape(pred.P(:,which_class), [length(x) length(y)]);
xx = reshape(Xgrid(:,1), [length(x) length(y)]);
yy = reshape(Xgrid(:,2), [length(x) length(y)]);
c = col_ass(which_class + 1,:);

d = 2;
for f=1:3
    step_color = (1-c(f))/step_potential;
    if c(f) == 1
        map(:,f) = ones(step_potential+1-d,1);
    else
        map(:,f) = 1-d*step_color:-step_color:c(f);
    end
end
map = [1 1 1; map];

%---------------------------------------------------
function [x,y,Xgrid] = makegriddata(X,step)
% make grid
rx = (max(X(:,1)) - min(X(:,1)));
ry = (max(X(:,2)) - min(X(:,2)));
xrange = [min(X(:,1))-rx/5 max(X(:,1))+rx/5];
yrange = [min(X(:,2))-ry/5 max(X(:,2))+ry/5];
x = xrange(1):(xrange(2)-xrange(1))/step:xrange(2);
y = yrange(1):(yrange(2)-yrange(1))/step:yrange(2);
[xx,yy] = meshgrid(x,y);
Xgrid = [xx(:),yy(:)];

% ---------------------------------------------------------
function which_class = find_class_with_labels(Lab_Tx,Lab_Ty)
if strcmp(Lab_Tx,'samples')
    str_lab = Lab_Ty;
else
    str_lab = Lab_Tx;
end
which_class = find_class_with_label_single(str_lab);

% ---------------------------------------------------------
function which_class = find_class_with_label_single(str_lab)
if strcmp(str_lab(8),' ')
    c = str_lab(7);
else
    c = str_lab(7:8);
end
which_class = str2num(c);

% ---------------------------------------------------------
function [T,lab_T,T_pred] = find_what_to_plot_sample(handles,x)

T = handles.store_for_plot{x}.val;
lab_T = handles.store_for_plot{x}.lab;
T_pred = handles.store_for_plot{x}.pred;

% ---------------------------------------------------------
function [T,lab_T] = find_what_to_plot_variable(handles,x)

T = handles.store_for_plot_variables{x}.val;
lab_T = handles.store_for_plot_variables{x}.lab;

% ---------------------------------------------------------
function handles = set_sample_combo(handles)

model = handles.model;
pred = handles.pred;
k = 0;
str_disp = {};

% samples ID
k = k + 1;
str_disp{k} = 'samples';
store_for_plot{k}.val = [1:size(model.settings.raw_data,1)]';
store_for_plot{k}.lab = 'samples';
store_for_plot{k}.pred = [];
if isstruct(pred)
    ntrain = size(model.settings.raw_data,1);
    store_for_plot{k}.pred = [ntrain + 1:ntrain + size(pred.X,1)]';
end

if strcmp(model.type,'plsda')
    % calculated y
    for g=1:size(model.yc,2)
        k = k + 1;
        str_disp{k} = ['y calc Class ' num2str(g)];
        store_for_plot{k}.val = model.yc(:,g);
        store_for_plot{k}.lab = ['calculated response Class ' num2str(g)];
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.yc(:,g);
        end
    end
    
    % cv y
    if isstruct(model.cv)
        for g=1:size(model.cv.yc,2)
            k = k + 1;
            str_disp{k} = ['y calc cv Class ' num2str(g)];
            store_for_plot{k}.val = model.cv.yc(:,g);
            store_for_plot{k}.lab = ['cross validated response Class ' num2str(g)];
            store_for_plot{k}.pred = [];
            if isstruct(pred)
                store_for_plot{k}.pred = pred.yc(:,g);
            end
        end
    end
    
    % components
    for p = 1:size(model.T,2)
        k = k + 1;
        str_disp{k} = ['scores on LV ' num2str(p)];
        store_for_plot{k}.val = model.T(:,p);
        lab = (['scores on LV ' num2str(p) ' - EV = ' num2str(round(model.expvar(p)*10000)/100) '%']);
        store_for_plot{k}.lab = lab;
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.T(:,p);
        end
    end
        
    % leverages
    k = k + 1;
    str_disp{k} = 'leverages'; 
    store_for_plot{k}.val = model.H;
    store_for_plot{k}.lab = 'leverages';
    store_for_plot{k}.pred = [];
    if isstruct(pred)
        store_for_plot{k}.pred = pred.H;
    end
    
    % Q residuals
    k = k + 1;
    str_disp{k} = 'Q residuals';
    store_for_plot{k}.val = model.Qres';
    store_for_plot{k}.lab = 'Q residuals';
    store_for_plot{k}.pred = [];
    if isstruct(pred)
        store_for_plot{k}.pred = pred.Qres';
    end
    % Hoteling
    k = k + 1;
    str_disp{k} = 'Hotelling T^2';
    store_for_plot{k}.val = model.Thot;
    store_for_plot{k}.lab = 'Hotelling T^2';
    store_for_plot{k}.pred = [];
    if isstruct(pred)
        store_for_plot{k}.pred = pred.Thot;
    end
end

if strcmp(model.type,'simca')
    % components
    for g = 1:max(model.settings.class)
        for p = 1:size(model.T{g},2)
            k = k + 1;
            str_disp{k} = ['c' num2str(g) ' scores on PC ' num2str(p)];
            store_for_plot{k}.val = model.T{g}(:,p);
            lab = (['class ' num2str(g) ' scores on PC ' num2str(p) ' - EV = ' num2str(round(model.modelpca{g}.exp_var(p)*10000)/100) '%']);
            store_for_plot{k}.lab = lab;
            store_for_plot{k}.pred = [];
            if isstruct(pred)
                store_for_plot{k}.pred = pred.T{g}(:,p);
            end
        end
    end
    
    for g = 1:max(model.settings.class)
        % Q residuals
        k = k + 1;
        str_disp{k} = ['c' num2str(g) ' Q residuals'];
        store_for_plot{k}.val = model.Qres{g};
        store_for_plot{k}.lab = ['class ' num2str(g) ' Q residuals'];
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.Qres{g};
        end
    end
    
    for g = 1:max(model.settings.class)
        % Hoteling
        k = k + 1;
        str_disp{k} = ['c' num2str(g) ' Hotelling T^2'];
        store_for_plot{k}.val = model.Thot{g};
        store_for_plot{k}.lab = ['class ' num2str(g) ' Hotelling T^2'];
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.Thot{g};
        end
    end
    
    for g = 1:max(model.settings.class)
        % Class distances
        k = k + 1;
        str_disp{k} = ['c' num2str(g) ' distance'];
        store_for_plot{k}.val = model.dist(:,g);
        store_for_plot{k}.lab = ['class ' num2str(g) ' normalised distance'];
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.dist(:,g);
        end
    end
end

if strcmp(model.type,'uneq')
    % components
    for g = 1:max(model.settings.class)
        for p = 1:size(model.T{g},2)
            k = k + 1;
            str_disp{k} = ['c' num2str(g) ' scores on PC ' num2str(p)];
            store_for_plot{k}.val = model.T{g}(:,p);
            lab = (['class ' num2str(g) ' scores on PC ' num2str(p) ' - EV = ' num2str(round(model.modelpca{g}.exp_var(p)*10000)/100) '%']);
            store_for_plot{k}.lab = lab;
            store_for_plot{k}.pred = [];
            if isstruct(pred)
                store_for_plot{k}.pred = pred.T{g}(:,p);
            end
        end
    end
       
    for g = 1:max(model.settings.class)
        % Hoteling
        k = k + 1;
        str_disp{k} = ['c' num2str(g) ' normalised Hot. T^2'];
        store_for_plot{k}.val = model.Thot_reduced(:,g);
        store_for_plot{k}.lab = ['class ' num2str(g) ' normalised Hotelling T^2'];
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.Thot_reduced(:,g);
        end
    end
    
end

if (strcmp(model.type,'lda') || strcmp(model.type,'pcalda')) && strcmp(handles.showspecificmodel,'none')
    % scores on canonical variables
    for g=1:size(model.S,2)
        k = k + 1;
        str_disp{k} = ['scores on CV ' num2str(g)];
        store_for_plot{k}.val = model.S(:,g);
        store_for_plot{k}.lab = ['scores on canonical variable ' num2str(g)];
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.S(:,g);
        end
    end
end
if (strcmp(model.type,'pcalda') && strcmp(handles.showspecificmodel,'pca')) || (strcmp(model.type,'pcaqda') && strcmp(handles.showspecificmodel,'pca'))
    % components
    for p = 1:size(model.settings.modelpca.T,2)
        k = k + 1;
        str_disp{k} = ['scores on PC ' num2str(p)];
        store_for_plot{k}.val = model.settings.modelpca.T(:,p);
        lab = (['scores on PC ' num2str(p) ' - EV = ' num2str(round(model.settings.modelpca.exp_var(p)*10000)/100) '%']);
        store_for_plot{k}.lab = lab;
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.T(:,p);
        end
    end
    % Q residuals
    k = k + 1;
    str_disp{k} = 'Q residuals';
    store_for_plot{k}.val = model.settings.modelpca.Qres';
    store_for_plot{k}.lab = 'Q residuals';
    store_for_plot{k}.pred = [];
    if isstruct(pred)
        store_for_plot{k}.pred = pred.modelpca.Qres_pred';
    end
    % Hoteling
    k = k + 1;
    str_disp{k} = 'Hotelling T^2';
    store_for_plot{k}.val = model.settings.modelpca.Thot';
    store_for_plot{k}.lab = 'Hotelling T^2';
    store_for_plot{k}.pred = [];
    if isstruct(pred)
        store_for_plot{k}.pred = pred.modelpca.Thot_pred';
    end
end

if strcmp(model.type,'svm')
    % distances
    k = k + 1;
    str_disp{k} = 'distance'; 
    store_for_plot{k}.val = model.dist;
    store_for_plot{k}.lab = 'distance from class boundary';
    store_for_plot{k}.pred = [];
    if isstruct(pred)
        store_for_plot{k}.pred = pred.dist;
    end
    % alpha
    k = k + 1;
    str_disp{k} = 'alpha'; 
    store_for_plot{k}.val = model.alpha;
    store_for_plot{k}.lab = 'alpha';
    store_for_plot{k}.pred = [];
end

if strcmp(model.type,'pf')
    % potential
    for g=1:size(model.P,2)
        k = k + 1;
        str_disp{k} = ['potential class ' num2str(g)];
        store_for_plot{k}.val = model.P(:,g);
        store_for_plot{k}.lab = ['potential class ' num2str(g)];
        store_for_plot{k}.pred = [];
        if isstruct(pred)
            store_for_plot{k}.pred = pred.P(:,g);
        end
    end
end

set(handles.x_pop_sample,'String',str_disp);
set(handles.x_pop_sample,'Value',1);
set(handles.y_pop_sample,'String',str_disp);
set(handles.y_pop_sample,'Value',2);
handles.store_for_plot = store_for_plot;

% ---------------------------------------------------------
function handles = set_variable_combo(handles,x)

model = handles.model;
k = 0;
str_disp = {};

% variables ID
k = k + 1;
str_disp{k} = 'variables';
store_for_plot_variables{k}.val = [1:size(model.settings.raw_data,2)]';
store_for_plot_variables{k}.lab = 'variables';

if strcmp(model.type,'plsda')
    for p = 1:size(model.b,2)
        k = k + 1;
        str_disp{k} = ['coefficients class ' num2str(p)];
        store_for_plot_variables{k}.val = model.b(:,p);
        lab = (['coefficients for class ' num2str(p)]);
        store_for_plot_variables{k}.lab = lab;
        store_for_plot_variables{k}.pred = [];
    end
    for p = 1:size(model.P,2)
        k = k + 1;
        str_disp{k} = ['loadings on LV ' num2str(p)];
        store_for_plot_variables{k}.val = model.P(:,p);
        lab = (['loadings on LV ' num2str(p) ' - EV = ' num2str(round(model.expvar(p)*10000)/100) '%']);
        store_for_plot_variables{k}.lab = lab;
        store_for_plot_variables{k}.pred = [];
    end
    for p = 1:size(model.W,2)
        k = k + 1;
        str_disp{k} = ['weights on LV ' num2str(p)];
        store_for_plot_variables{k}.val = model.W(:,p);
        lab = (['weights on LV ' num2str(p) ' - EV = ' num2str(round(model.expvar(p)*10000)/100) '%']);
        store_for_plot_variables{k}.lab = lab;
        store_for_plot_variables{k}.pred = [];
    end
end

if strcmp(model.type,'simca') || strcmp(model.type,'uneq')
    for g = 1:max(model.settings.class)
        for p = 1:size(model.T{g},2)
            k = k + 1;
            str_disp{k} = ['c' num2str(g) ' loadings on PC ' num2str(p)];
            store_for_plot_variables{k}.val = model.modelpca{g}.L(:,p);
            lab = (['class ' num2str(g) ' loadings on PC ' num2str(p) ' - EV = ' num2str(round(model.modelpca{g}.exp_var(p)*10000)/100) '%']);
            store_for_plot_variables{k}.lab = lab;
            store_for_plot_variables{k}.pred = [];
        end
    end
end

if strcmp(model.type,'lda') | strcmp(model.type,'pcalda') && strcmp(handles.showspecificmodel,'none')
    for p = 1:size(model.L,2)
        k = k + 1;
        str_disp{k} = ['loadings on CV ' num2str(p)];
        store_for_plot_variables{k}.val = model.L(:,p);
        lab = (['loadings on canonical variable ' num2str(p)]);
        store_for_plot_variables{k}.lab = lab;
        store_for_plot_variables{k}.pred = [];
    end
    for p = 1:size(model.Lstd,2)
        k = k + 1;
        str_disp{k} = ['std loads on CV ' num2str(p)];
        store_for_plot_variables{k}.val = model.Lstd(:,p);
        lab = (['standardized loadings on canonical variable ' num2str(p)]);
        store_for_plot_variables{k}.lab = lab;
        store_for_plot_variables{k}.pred = [];
    end
end

if (strcmp(model.type,'pcalda') && strcmp(handles.showspecificmodel,'pca')) || strcmp(model.type,'pcaqda') && strcmp(handles.showspecificmodel,'pca')
    % components
    for p = 1:size(model.settings.modelpca.L,2)
        k = k + 1;
        str_disp{k} = ['loadings on PC ' num2str(p)];
        store_for_plot_variables{k}.val = model.settings.modelpca.L(:,p);
        lab = (['loadings on LV ' num2str(p) ' - EV = ' num2str(round(model.settings.modelpca.exp_var(p)*10000)/100) '%']);
        store_for_plot_variables{k}.lab = lab;
        store_for_plot_variables{k}.pred = [];
    end
end

if strcmp(model.type,'svm')
    k = k + 1;
    str_disp{k} = ['none'];
    store_for_plot_variables{k}.val = [];
    lab = (['no available results']);
    store_for_plot_variables{k}.lab = lab;
    store_for_plot_variables{k}.pred = [];
end

if strcmp(model.type,'pf')
    k = k + 1;
    str_disp{k} = ['none'];
    store_for_plot_variables{k}.val = [];
    lab = (['no available results']);
    store_for_plot_variables{k}.lab = lab;
    store_for_plot_variables{k}.pred = [];
end

set(handles.x_pop_variable,'String',str_disp);
set(handles.x_pop_variable,'Value',1);
set(handles.y_pop_variable,'String',str_disp);
set(handles.y_pop_variable,'Value',2);

handles.store_for_plot_variables = store_for_plot_variables;
