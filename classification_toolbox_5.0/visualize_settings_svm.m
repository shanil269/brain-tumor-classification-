function varargout = visualize_settings_svm(varargin)

% visualize_settings_svm opens a graphical interface for prepearing
% settings of PLSDA
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
                   'gui_OpeningFcn', @visualize_settings_svm_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_svm_OutputFcn, ...
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


% --- Executes just before visualize_settings_pc_pc is made visible.
function visualize_settings_svm_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[129.7143 33.7647 59.8571 25.7059]);
set(handles.visualize_settings_svm,'Position',[129.7143 33.7647 59.8571 25.7059]);
set(handles.text21,'Position',[5.7143 13.4412 22.8571 1.1176]);
set(handles.pop_cost,'Position',[5.5714 11.6765 27 1.7059]);
set(handles.text20,'Position',[5.7143 16.3824 22.8571 1.1176]);
set(handles.pop_param,'Position',[5.5714 14.6765 27 1.7059]);
set(handles.text19,'Position',[5.7143 19.3824 22.8571 1.1176]);
set(handles.pop_kernel,'Position',[5.5714 17.6765 27 1.7059]);
set(handles.pop_menu_cv_type,'Position',[5.5714 5.6765 27 1.7059]);
set(handles.pop_menu_cv_groups,'Position',[5.5714 2.6176 27 1.7059]);
set(handles.text18,'Position',[5.7143 7.4412 21.4286 1.1176]);
set(handles.text17,'Position',[5.7143 4.3824 21.4286 1.1176]);
set(handles.text16,'Position',[5.7143 22.3824 22.8571 1.1176]);
set(handles.pop_menu_scaling,'Position',[5.5714 20.6765 27 1.7059]);
set(handles.text7,'Position',[5.7143 10.4412 32.1429 1.1176]);
set(handles.text3,'Position',[4.5 23.7093 12.25 1.4423]);
set(handles.pop_menu_numcomp,'Position',[5.5714 8.6765 27 1.7059]);
set(handles.button_cancel,'Position',[39.8571 19.5113 17 1.8]);
set(handles.button_calculate_model,'Position',[39.8571 22.5882 17 1.8]);
set(handles.frame1,'Position',[2.5714 1.5 36.2857 22.9412]);
set(handles.output,'Position',[129.7143 33.7647 59.8571 25.7059]);
movegui(handles.visualize_settings_svm,'center')
handles.model_is_present = varargin{1};
model_loaded = varargin{2};
handles.num_samples = varargin{3};
handles.type_of_settings = varargin{4};

% set cv type combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'venetian blinds cross validation';
str_disp{3} = 'contiguous blocks cross validation';
if ~strcmp (handles.type_of_settings,'selparam')
    str_disp{4} = 'montecarlo 20% out';
    str_disp{5} = 'bootstrap';
end
set(handles.pop_menu_cv_type,'String',str_disp);

% set cv groups combo
handles = set_cvgroups_combo(handles);

% set scaling combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'mean centering';
str_disp{3} = 'autoscaling';
set(handles.pop_menu_scaling,'String',str_disp);

% set kernel combo
str_disp={};
str_disp{1} = 'linear';
str_disp{2} = 'rbf';
str_disp{3} = 'polynomial';
set(handles.pop_kernel,'String',str_disp);

% set cost combo
handles.cost_seq = [0.1 1 10 100 1000];
str_disp={};
for j=1:length(handles.cost_seq)
    str_disp{j} = handles.cost_seq(j);
end
set(handles.pop_cost,'String',str_disp);
set(handles.pop_cost,'Value',1);

% set numcomp combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'automatic';
for j=3:12
    str_disp{j} = num2str(j-2);
end
set(handles.pop_menu_numcomp,'String',str_disp);

% initialize values
handles.domodel = 0;
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2
    if strcmp(model_loaded.type,'svm')
        if strcmp(model_loaded.settings.pret_type,'none')
            set_this = 1;
        elseif strcmp(model_loaded.settings.pret_type,'cent')
            set_this = 2;
        else
            set_this = 3;
        end
        set(handles.pop_menu_scaling,'Value',set_this);
        if isnan(model_loaded.settings.num_comp)
            set_this = 1;
        else
            set_this = model_loaded.settings.num_comp + 2;
        end
        set(handles.pop_menu_numcomp,'Value',set_this);
        if strcmp(model_loaded.settings.kernel,'linear')
            set(handles.pop_kernel,'Value',1);
        elseif strcmp(model_loaded.settings.kernel,'rbf')
            set(handles.pop_kernel,'Value',2);
        else
            set(handles.pop_kernel,'Value',3);
        end
        set_this = log10(model_loaded.settings.C) + 2;
        if mod(set_this,1) == 0 
            set(handles.pop_cost,'Value',set_this);
        else
            set(handles.pop_cost,'Value',1);
        end
        set_this = model_loaded.settings.kernelpar;
        handles = setparamcombo(handles,set_this);
    else
        set(handles.pop_menu_scaling,'Value',3);
        set(handles.pop_menu_numcomp,'Value',1);
        handles = setparamcombo(handles,NaN);
    end
else
    set(handles.pop_menu_scaling,'Value',3);
    set(handles.pop_menu_numcomp,'Value',1);
    handles = setparamcombo(handles,NaN);
end

% enable/disable combo
handles = enable_disable(handles);
guidata(hObject, handles);
uiwait(handles.visualize_settings_svm);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_svm_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    nc = get(handles.pop_menu_numcomp,'Value');
    nc = nc - 2;
    if nc < 0; nc = NaN; end
    varargout{1} = nc;
    if get(handles.pop_menu_scaling,'Value') == 1
        set_this = 'none';
    elseif get(handles.pop_menu_scaling,'Value') == 2
        set_this = 'cent';
    else
        set_this = 'auto';
    end
    varargout{2} = set_this;
    w = get(handles.pop_menu_cv_groups,'Value');
    cv_groups = get(handles.pop_menu_cv_groups,'String');
    cv_groups = cv_groups{w};
    cv_groups = str2num(cv_groups);
    varargout{3} = cv_groups;
    if get(handles.pop_menu_cv_type,'Value') == 1
        set_this = 'none';
    elseif get(handles.pop_menu_cv_type,'Value') == 2
        set_this = 'vene';
    elseif get(handles.pop_menu_cv_type,'Value') == 3
        set_this = 'cont'; 
    elseif get(handles.pop_menu_cv_type,'Value') == 4
        set_this = 'rand';
    else
        set_this = 'boot';
    end
    varargout{4} = set_this;
    varargout{5} = handles.domodel;
    set_this = get(handles.pop_kernel,'String');
    w = get(handles.pop_kernel,'Value');
    kernelhere = set_this{w};
    varargout{6} = kernelhere;
    paramhere = get(handles.pop_param,'String');
    paramhere = paramhere(get(handles.pop_param,'Value'));
    paramhere = paramhere{1};
    if strcmp(kernelhere,'linear')
        varargout{7} = [];
    else
        varargout{7} = str2num(paramhere);
    end
    paramhere = get(handles.pop_cost,'String');
    paramhere = paramhere(get(handles.pop_cost,'Value'));
    paramhere = paramhere{1};
    varargout{8} = str2num(paramhere);
    delete(handles.visualize_settings_svm)
else
    handles.settings.numcomp = NaN;
    handles.settings.scaling = NaN;
    handles.settings.cv_groups = NaN;
    handles.settings.cv_type = NaN;
    handles.settings.kernel = NaN;
    handles.settings.perc = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.numcomp;
    varargout{2} = handles.settings.scaling;
    varargout{3} = handles.settings.cv_groups;
    varargout{4} = handles.settings.cv_type;
    varargout{5} = handles.domodel;
    varargout{6} = NaN;
    varargout{7} = NaN;
    varargout{8} = NaN;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_svm)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_svm)

% --- Executes during object creation, after setting all properties.
function pop_menu_numcomp_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_numcomp.
function pop_menu_numcomp_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_scaling_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_scaling.
function pop_menu_scaling_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_cv_groups_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_cv_groups.
function pop_menu_cv_groups_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_cv_type_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_cv_type.
function pop_menu_cv_type_Callback(hObject, eventdata, handles)
handles = set_cvgroups_combo(handles);
handles = enable_disable(handles);

% --- Executes during object creation, after setting all properties.
function pop_kernel_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_kernel.
function pop_kernel_Callback(hObject, eventdata, handles)
handles = setparamcombo(handles,NaN);

% --- Executes on selection change in pop_param.
function pop_param_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_param_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop_cost.
function pop_cost_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_cost_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ------------------------------------------------------------------------
function handles = enable_disable(handles)

val = get(handles.pop_menu_cv_type,'value');
if val == 1
    set(handles.pop_menu_cv_groups,'Enable','off');    
else
    set(handles.pop_menu_cv_groups,'Enable','on');
end

if strcmp(handles.type_of_settings,'selparam')
    set(handles.pop_cost,'Enable','off');
    set(handles.pop_param,'Enable','off');
else
    set(handles.pop_cost,'Enable','on');
    set(handles.pop_param,'Enable','on');    
end

% ------------------------------------------------------------------------
function handles = setparamcombo(handles,loaded_param)
% set kernel parameter combo
val = get(handles.pop_kernel,'string');
w = get(handles.pop_kernel,'value');
val = val{w};
if strcmp(val,'linear')
    str_disp{1} = 'none';
    set(handles.pop_param,'String',str_disp);
    set(handles.pop_param,'Value',1);
else
    kernalparam_seq = [0.05	0.07	0.10	0.14	0.20	0.28	0.40	0.57	0.80	1.13	1.60	2.26	3.20	4.53	6.40	9.00];
    handles.kernalparam_seq = kernalparam_seq;
    str_disp={};
    for j=1:length(handles.kernalparam_seq)
        str_disp{j} = handles.kernalparam_seq(j);
    end
    set(handles.pop_param,'String',str_disp);
    if isnan(loaded_param)
        set(handles.pop_param,'Value',1);
    else
        w = find(kernalparam_seq == loaded_param);
        if length(w) == 1
            set(handles.pop_param,'Value',w);
        else
            set(handles.pop_param,'Value',1);
        end
    end
end

% --------------------------------------------------------
function handles = set_cvgroups_combo(handles)
str_disp={};
if get(handles.pop_menu_cv_type,'Value') < 4
    cv_group(1) = 2;
    cv_group(2) = 3;
    cv_group(3) = 4;
    cv_group(4) = 5;
    cv_group(5) = 10;
    cv_group(6) = handles.num_samples;
    for j=1:length(cv_group)
        str_disp{j} = cv_group(j);
    end
    set(handles.text17,'String','number of cv groups:');
    set(handles.pop_menu_cv_groups,'String',str_disp);
    set(handles.pop_menu_cv_groups,'Value',5);
else
    cv_group(1) = 100;
    cv_group(2) = 500;
    cv_group(3) = 1000;
    for j=1:length(cv_group)
        str_disp{j} = cv_group(j);
    end
    set(handles.text17,'String','number of iterations:');
    set(handles.pop_menu_cv_groups,'String',str_disp);
    set(handles.pop_menu_cv_groups,'Value',3);
end
