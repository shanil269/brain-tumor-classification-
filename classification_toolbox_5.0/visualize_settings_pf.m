function varargout = visualize_settings_pf(varargin)

% visualize_settings_pf opens a graphical interface for prepearing
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
                   'gui_OpeningFcn', @visualize_settings_pf_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_pf_OutputFcn, ...
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


% --- Executes just before visualize_settings_pf is made visible.
function visualize_settings_pf_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[129.7143 34.6471 85.1429 24.8235]);
set(handles.visualize_settings_pf,'Position',[129.7143 34.6471 85.1429 24.8235]);
set(handles.text25,'Position',[32.5714 11.1176 27.5714 1.1176]);
set(handles.pop_menu_numcomp,'Position',[32.7143 8.9412 24 2.1176]);
set(handles.text24,'Position',[32.7143 14.4118 27 1.1176]);
set(handles.pop_menu_percentiles,'Position',[32.7143 12.1765 24 2.1176]);
set(handles.text23,'Position',[5.5714 7.7059 23 1.1176]);
set(handles.pop_menu_smoot_c5,'Position',[5.5714 5.4706 24 2.1176]);
set(handles.text22,'Position',[5.5714 11.1176 23 1.1176]);
set(handles.pop_menu_smoot_c4,'Position',[5.5714 8.9412 24 2.1176]);
set(handles.text21,'Position',[5.5714 14.4118 23 1.1176]);
set(handles.pop_menu_smoot_c3,'Position',[5.5714 12.1765 24 2.1176]);
set(handles.text20,'Position',[5.5714 17.7059 21.4286 1.1176]);
set(handles.pop_menu_smoot_c2,'Position',[5.5714 15.5294 24 2.1176]);
set(handles.text19,'Position',[32.7143 17.7059 20.4286 1.1176]);
set(handles.pop_menu_kernel,'Position',[32.7143 15.5294 24 2.1176]);
set(handles.pop_menu_cv_type,'Position',[32.7143 5.4706 24 2.1176]);
set(handles.pop_menu_cv_groups,'Position',[32.7143 2.2353 24 2.1176]);
set(handles.text18,'Position',[32.7143 7.7059 21.2857 1.1176]);
set(handles.text17,'Position',[32.7143 4.4118 23.1429 1.1176]);
set(handles.text16,'Position',[32.7143 21.0588 25 1.1176]);
set(handles.pop_menu_scaling,'Position',[32.7143 18.8235 24 2.1176]);
set(handles.text7,'Position',[5.5714 21.0588 21 1.1176]);
set(handles.text3,'Position',[4.5 22.6765 12.25 1.4423]);
set(handles.pop_menu_smoot_c1,'Position',[5.5714 18.8235 24 2.1176]);
set(handles.button_cancel,'Position',[65.1071 18.5962 17.6 1.7]);
set(handles.button_calculate_model,'Position',[65.1071 21.6731 17.6 1.7]);
set(handles.frame1,'Position',[2.5714 1.1176 58.5714 22.2353]);
set(handles.output,'Position',[129.7143 34.6471 85.1429 24.8235]);
movegui(handles.visualize_settings_pf,'center')
handles.model_is_present = varargin{1};
model_loaded = varargin{2};
handles.num_samples = varargin{3};
handles.num_classes = varargin{4};
handles.smoot_range = [0.1:0.1:1.2];

% set cv type combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'venetian blinds cross validation';
str_disp{3} = 'contiguous blocks cross validation';
str_disp{4} = 'montecarlo 20% out';
str_disp{5} = 'bootstrap';
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
str_disp{1} = 'gaussian';
str_disp{2} = 'triangular';
set(handles.pop_menu_kernel,'String',str_disp);

% set percentile combo
str_disp={};
perc_list(1) = 80;
perc_list(2) = 90;
perc_list(3) = 95;
perc_list(4) = 99;
for j=1:length(perc_list)
    str_disp{j} = perc_list(j);
end
set(handles.pop_menu_percentiles,'String',str_disp);
set(handles.pop_menu_percentiles,'Value',3);

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
    if strcmp(model_loaded.type,'pf')
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
        if strcmp(model_loaded.settings.type,'gaus')
            set(handles.pop_menu_kernel,'Value',1);
        else
            set(handles.pop_menu_kernel,'Value',2);
        end
        if model_loaded.settings.perc == 80
            set_this = 1;
        elseif model_loaded.settings.perc == 90
            set_this = 2;
        elseif model_loaded.settings.perc == 99
            set_this = 4;
        else
            set_this = 3;
        end
        set(handles.pop_menu_percentiles,'Value',set_this);
        handles = setval_in_combo(handles,model_loaded.settings.smoot);
    else
        set(handles.pop_menu_scaling,'Value',3);
        set(handles.pop_menu_kernel,'Value',1);
        handles = setval_in_combo(handles,ones(handles.num_classes,1)*0.1);
    end
else
    set(handles.pop_menu_scaling,'Value',3);
    set(handles.pop_menu_kernel,'Value',1);
    handles = setval_in_combo(handles,ones(handles.num_classes,1)*0.1);
end

% enable/disable combo
handles = enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings_pf);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_pf_OutputFcn(hObject, eventdata, handles)
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
    if get(handles.pop_menu_kernel,'Value')  == 1
        varargout{6} = 'gaus';
    else
        varargout{6} = 'tria';
    end
    perchere = get(handles.pop_menu_percentiles,'String');
    perchere = perchere(get(handles.pop_menu_percentiles,'Value'));
    perchere = str2num(perchere{1});
    varargout{7} = perchere;
    varargout{8} = getval_from_combo(handles);
    delete(handles.visualize_settings_pf)
else
    handles.settings.numcomp = NaN;
    handles.settings.scaling = NaN;
    handles.settings.cv_groups = NaN;
    handles.settings.cv_type = NaN;
    handles.settings.kernel = NaN;
    handles.settings.perc = NaN;
    handles.settings.smoot = NaN;
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
uiresume(handles.visualize_settings_pf)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_pf)

% --- Executes during object creation, after setting all properties.
function pop_menu_smoot_c1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_smoot_c1.
function pop_menu_smoot_c1_Callback(hObject, eventdata, handles)

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
function pop_menu_kernel_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_kernel.
function pop_menu_kernel_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_smoot_c2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_smoot_c2.
function pop_menu_smoot_c2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_smoot_c3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_smoot_c3.
function pop_menu_smoot_c3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_smoot_c4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_smoot_c4.
function pop_menu_smoot_c4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_smoot_c5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_smoot_c5.
function pop_menu_smoot_c5_Callback(hObject, eventdata, handles)

% --- Executes on selection change in pop_menu_percentiles.
function pop_menu_percentiles_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_percentiles_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop_menu_numcomp.
function pop_menu_numcomp_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_numcomp_CreateFcn(hObject, eventdata, handles)
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
if handles.num_classes < 5
    set(handles.pop_menu_smoot_c5,'Enable','off');
    set(handles.pop_menu_smoot_c5,'String','no class');
else
    set(handles.pop_menu_smoot_c5,'Enable','on');
end
if handles.num_classes < 4
    set(handles.pop_menu_smoot_c4,'Enable','off');
    set(handles.pop_menu_smoot_c4,'String','no class');
else
    set(handles.pop_menu_smoot_c4,'Enable','on');
end
if handles.num_classes < 3
    set(handles.pop_menu_smoot_c3,'Enable','off');
    set(handles.pop_menu_smoot_c3,'String','no class');
else
    set(handles.pop_menu_smoot_c3,'Enable','on');
end

% ------------------------------------------------------------------------
function handles = setval_in_combo(handles,smoot_list)
% combo smoothing
str_disp={};
for j=1:length(handles.smoot_range)
    str_disp{j} = num2str(handles.smoot_range(j));
end
for g=1:length(smoot_list)
    if g == 1
        set(handles.pop_menu_smoot_c1,'String',str_disp);
        w = find(handles.smoot_range == smoot_list(g));
        set(handles.pop_menu_smoot_c1,'Value',w);
    elseif g == 2
        set(handles.pop_menu_smoot_c2,'String',str_disp);
        w = find(handles.smoot_range == smoot_list(g));
        set(handles.pop_menu_smoot_c2,'Value',w);
    elseif g == 3
        set(handles.pop_menu_smoot_c3,'String',str_disp);
        w = find(handles.smoot_range == smoot_list(g));
        set(handles.pop_menu_smoot_c3,'Value',w);
    elseif g == 4
        set(handles.pop_menu_smoot_c4,'String',str_disp);
        w = find(handles.smoot_range == smoot_list(g));
        set(handles.pop_menu_smoot_c4,'Value',w);
    elseif g == 5
        set(handles.pop_menu_smoot_c5,'String',str_disp);
        w = find(handles.smoot_range == smoot_list(g));
        set(handles.pop_menu_smoot_c5,'Value',w);
    end
end

% ------------------------------------------------------------------------
function num_val = getval_from_combo(handles)
for g=1:handles.num_classes
    if g == 1
        w = get(handles.pop_menu_smoot_c1,'Value');
        num_val(g) = handles.smoot_range(w);
    elseif g == 2
        w = get(handles.pop_menu_smoot_c2,'Value');
        num_val(g) = handles.smoot_range(w);
    elseif g == 3
        w = get(handles.pop_menu_smoot_c3,'Value');
        num_val(g) = handles.smoot_range(w);
    elseif g == 4
        w = get(handles.pop_menu_smoot_c4,'Value');
        num_val(g) = handles.smoot_range(w);
    elseif g == 5
        w = get(handles.pop_menu_smoot_c5,'Value');
        num_val(g) = handles.smoot_range(w);
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