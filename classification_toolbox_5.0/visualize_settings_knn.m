function varargout = visualize_settings_knn(varargin)

% visualize_settings_knn opens a graphical interface for prepearing
% settings of KNN
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
                   'gui_OpeningFcn', @visualize_settings_knn_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_knn_OutputFcn, ...
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


% --- Executes just before visualize_settings_knn_pc is made visible.
function visualize_settings_knn_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 38.1765 56.7143 21.2941]);
set(handles.visualize_settings_knn,'Position',[103.8571 38.1765 56.7143 21.2941]);
set(handles.text19,'Position',[4.6 14.6923 22.8 1.1538]);
set(handles.pop_menu_distance,'Position',[4.6 12.9231 26.8 1.6923]);
set(handles.pop_menu_cv_type,'Position',[4.6 6.4615 26.6 1.6923]);
set(handles.pop_menu_cv_groups,'Position',[4.6 3.0769 26.8 1.6923]);
set(handles.text18,'Position',[4.8 8.1538 22.8 1.1538]);
set(handles.text17,'Position',[4.8 4.7692 22.8 1.1538]);
set(handles.text16,'Position',[4.6 11.5385 22.8 1.1538]);
set(handles.pop_menu_scaling,'Position',[4.4 9.7692 26.6 1.6923]);
set(handles.text7,'Position',[4.4 17.9231 22.8 1.1538]);
set(handles.text3,'Position',[3.6 19.2308 9.8 1.1538]);
set(handles.pop_menu_numk,'Position',[4.4 16.1538 26.8 1.6923]);
set(handles.button_cancel,'Position',[36.8 12.6923 17.6 1.7692]);
set(handles.button_calculate_model,'Position',[36.8 15.1538 17.2 1.7692]);
set(handles.frame1,'Position',[2 1.8462 32.4 17.6923]);
set(handles.output,'Position',[103.8571 38.1765 56.7143 21.2941]);
movegui(handles.visualize_settings_knn,'center')
handles.model_is_present = varargin{1};
model_loaded = varargin{2};
handles.num_samples = varargin{3};
handles.disable_comp = varargin{4};
handles.maxk = 10;

% set cv type combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'venetian blinds cross validation';
str_disp{3} = 'contiguous blocks cross validation';
if handles.disable_comp == 0
    str_disp{4} = 'montecarlo 20% out';
    str_disp{5} = 'bootstrap';
end
set(handles.pop_menu_cv_type,'String',str_disp);

% set distance type combo
str_disp={};
str_disp{1} = 'euclidean';
str_disp{2} = 'mahalanobis';
str_disp{3} = 'cityblock';
str_disp{4} = 'minkowski';
set(handles.pop_menu_distance,'String',str_disp);

% set cv groups combo
handles = set_cvgroups_combo(handles);

% set scaling combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'mean centering';
str_disp{3} = 'autoscaling';
set(handles.pop_menu_scaling,'String',str_disp);

% set k combo
str_disp={};
for j=1:handles.maxk
    str_disp{j} = num2str(j);
end
set(handles.pop_menu_numk,'String',str_disp);

% initialize values
handles.domodel = 0;
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2 & handles.disable_comp == 0 & strcmp(model_loaded.type,'knn')
    if strcmp(model_loaded.settings.param.pret_type,'none')
        set_this = 1;
    elseif strcmp(model_loaded.settings.param.pret_type,'cent')
        set_this = 2;
    else
        set_this = 3;
    end
    set(handles.pop_menu_scaling,'Value',set_this);
    set(handles.pop_menu_numk,'Value',model_loaded.settings.K);
    if strcmp(model_loaded.settings.dist_type,'euclidean')
        set_this = 1;
    elseif strcmp(model_loaded.settings.dist_type,'mahalanobis')
        set_this = 2;
    elseif strcmp(model_loaded.settings.dist_type,'cityblock')
        set_this = 3;
    else
        set_this = 4;
    end    
    set(handles.pop_menu_distance,'Value',set_this);
else
    set(handles.pop_menu_scaling,'Value',3);
    set(handles.pop_menu_numk,'Value',handles.maxk);
end

% enable/disable combo
handles = enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings_knn);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_knn_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    varargout{1} = get(handles.pop_menu_numk,'Value');
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
    if get(handles.pop_menu_distance,'Value') == 1
        set_this = 'euclidean';
    elseif get(handles.pop_menu_distance,'Value') == 2
        set_this = 'mahalanobis';
    elseif get(handles.pop_menu_distance,'Value') == 3
        set_this = 'cityblock';
    else
        set_this = 'minkowski'; 
    end    
    varargout{6} = set_this;
    delete(handles.visualize_settings_knn)
else
    handles.settings.numcomp = NaN;
    handles.settings.scaling = NaN;
    handles.settings.cv_groups = NaN;
    handles.settings.cv_type = NaN;
    handles.settings.dist_type = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.numcomp;
    varargout{2} = handles.settings.scaling;
    varargout{3} = handles.settings.cv_groups;
    varargout{4} = handles.settings.cv_type;
    varargout{5} = handles.domodel;
    varargout{6} = handles.settings.dist_type;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_knn)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_knn)

% --- Executes during object creation, after setting all properties.
function pop_menu_numk_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_numk.
function pop_menu_numk_Callback(hObject, eventdata, handles)

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

% ------------------------------------------------------------------------
function handles = enable_disable(handles)
val = get(handles.pop_menu_cv_type,'value');
if val == 1
    set(handles.pop_menu_cv_groups,'Enable','off');    
else
    set(handles.pop_menu_cv_groups,'Enable','on');
end

if handles.disable_comp == 1
    set(handles.pop_menu_numk,'Enable','off');
else
    set(handles.pop_menu_numk,'Enable','on');
end

% --- Executes during object creation, after setting all properties.
function pop_menu_distance_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_distance.
function pop_menu_distance_Callback(hObject, eventdata, handles)

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
