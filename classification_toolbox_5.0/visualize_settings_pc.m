function varargout = visualize_settings_pc(varargin)

% visualize_settings_pc opens a graphical interface for prepearing
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
                   'gui_OpeningFcn', @visualize_settings_pc_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_pc_OutputFcn, ...
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
function visualize_settings_pc_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 38 57.2857 21.4706]);
set(handles.visualize_settings_pc,'Position',[103.8571 38 57.2857 21.4706]);
set(handles.text19,'Position',[4.6 11.2308 22.8 1.1538]);
set(handles.pop_menu_assignation,'Position',[4.4 9.4615 26.6 1.6923]);
set(handles.pop_menu_cv_type,'Position',[4.6 5.8462 26.6 1.6923]);
set(handles.pop_menu_cv_groups,'Position',[4.6 2.2308 26.8 1.6923]);
set(handles.text18,'Position',[4.8 7.4615 22.8 1.1538]);
set(handles.text17,'Position',[4.8 3.8462 22.8 1.1538]);
set(handles.text16,'Position',[4.6 14.9231 22.8 1.1538]);
set(handles.pop_menu_scaling,'Position',[4.4 13.1538 26.6 1.6923]);
set(handles.text7,'Position',[4.4 18.4615 23.8 1.1538]);
set(handles.text3,'Position',[3.6 20 9.8 1.1538]);
set(handles.pop_menu_numcomp,'Position',[4.4 16.6923 26.8 1.6923]);
set(handles.button_cancel,'Position',[36.8 16.0769 17.6 1.7692]);
set(handles.button_calculate_model,'Position',[36.8 18.5385 17.2 1.7692]);
set(handles.frame1,'Position',[2 1.2308 32.6 19.0769]);
set(handles.output,'Position',[103.8571 38 57.2857 21.4706]);
movegui(handles.visualize_settings_pc,'center')
handles.maxcomp = varargin{1};
handles.model_is_present = varargin{2};
model_loaded = varargin{3};
handles.num_samples = varargin{4};
handles.disable_comp = varargin{5};
handles.model_here = varargin{6};

% set form name
if strcmp(handles.model_here,'plsda')
    set(handles.visualize_settings_pc,'Name','PLS-DA settings')
else
    set(handles.visualize_settings_pc,'Name','SIMCA settings')
end

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

% set cv groups combo
handles = set_cvgroups_combo(handles);

% set scaling combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'mean centering';
str_disp{3} = 'autoscaling';
set(handles.pop_menu_scaling,'String',str_disp);

% set assignation combo
str_disp={};
if strcmp(handles.model_here,'plsda')
    str_disp{1} = 'bayes';
    str_disp{2} = 'max';
    set(handles.pop_menu_assignation,'String',str_disp);
else
    str_disp{1} = 'class modeling';
    str_disp{2} = 'dist';
    set(handles.pop_menu_assignation,'String',str_disp);
    set(handles.pop_menu_assignation,'Enable','off');
end

% set numcomp combo
str_disp={};
for j=1:handles.maxcomp
    str_disp{j} = num2str(j);
end
set(handles.pop_menu_numcomp,'String',str_disp);

% initialize values
handles.domodel = 0;
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2 & handles.disable_comp == 0
    if strcmp(model_loaded.type,'plsda')
        if strcmp(model_loaded.settings.pret_type,'none')
            set_this = 1;
        elseif strcmp(model_loaded.settings.pret_type,'cent')
            set_this = 2;
        else
            set_this = 3;
        end
        set(handles.pop_menu_scaling,'Value',set_this);
        set(handles.pop_menu_numcomp,'Value',size(model_loaded.T,2));    
        if strcmp(model_loaded.settings.assign_method,'bayes')
            set(handles.pop_menu_assignation,'Value',1);
        else
            set(handles.pop_menu_assignation,'Value',2);
        end
    else
        set(handles.pop_menu_scaling,'Value',3);
        set(handles.pop_menu_numcomp,'Value',handles.maxcomp);
    end
else
    set(handles.pop_menu_scaling,'Value',3);
    set(handles.pop_menu_numcomp,'Value',handles.maxcomp);
end

% enable/disable combo
handles = enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings_pc);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_pc_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    varargout{1} = get(handles.pop_menu_numcomp,'Value');
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
    if get(handles.pop_menu_assignation,'Value')  == 1
        if strcmp(handles.model_here,'plsda')
            varargout{6} = 'bayes';
        else
            varargout{6} = 'class modeling';
        end
    else
        if strcmp(handles.model_here,'plsda')
            varargout{6} = 'max';
        else
            varargout{6} = 'dist';
        end
    end
    delete(handles.visualize_settings_pc)
else
    handles.settings.numcomp = NaN;
    handles.settings.scaling = NaN;
    handles.settings.cv_groups = NaN;
    handles.settings.cv_type = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.numcomp;
    varargout{2} = handles.settings.scaling;
    varargout{3} = handles.settings.cv_groups;
    varargout{4} = handles.settings.cv_type;
    varargout{5} = handles.domodel;
    varargout{6} = NaN;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_pc)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_pc)

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

% ------------------------------------------------------------------------
function handles = enable_disable(handles)
val = get(handles.pop_menu_cv_type,'value');
if val == 1
    set(handles.pop_menu_cv_groups,'Enable','off');    
else
    set(handles.pop_menu_cv_groups,'Enable','on');
end

if handles.disable_comp == 1
    set(handles.pop_menu_numcomp,'Enable','off');
else
    set(handles.pop_menu_numcomp,'Enable','on');
end

% --- Executes during object creation, after setting all properties.
function pop_menu_assignation_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_assignation.
function pop_menu_assignation_Callback(hObject, eventdata, handles)

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
