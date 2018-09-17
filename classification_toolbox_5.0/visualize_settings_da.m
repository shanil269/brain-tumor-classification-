function varargout = visualize_settings_da(varargin)

% visualize_settings_da opens a graphical interface for prepearing
% settings of DA
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
                   'gui_OpeningFcn', @visualize_settings_da_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_da_OutputFcn, ...
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


% --- Executes just before visualize_settings_da is made visible.
function visualize_settings_da_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 45.4706 58.4286 14]);
set(handles.visualize_settings_da,'Position',[103.8571 45.4706 58.4286 14]);
set(handles.text18,'Position',[5.5714 12.0588 10.5714 1.2941]);
set(handles.text17,'Position',[6.5714 10.9412 28.5714 1.0588]);
set(handles.pop_menu_disc_type,'Position',[6.2857 9.1765 27 1.7]);
set(handles.text16,'Position',[6.2857 7.4118 28.5714 1.0588]);
set(handles.pop_menu_cv_type,'Position',[6 5.6471 27 1.7]);
set(handles.text7,'Position',[6 3.8824 28.5714 1.1176]);
set(handles.text3,'Position',[5 15.526 12.25 1.4423]);
set(handles.pop_menu_cv_groups,'Position',[6 2.1765 27 1.7]);
set(handles.button_cancel,'Position',[39.7143 8.4118 17 1.8235]);
set(handles.button_calculate_model,'Position',[39.7143 10.7647 17 1.8235]);
set(handles.frame1,'Position',[2.1429 0.94118 35.4286 11.6471]);
set(handles.output,'Position',[103.8571 45.4706 58.4286 14]);
movegui(handles.visualize_settings_da,'center')
handles.num_samples = varargin{1};
handles.model_is_present = varargin{2};
model_loaded = varargin{3};

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

% set disc type combo
str_disp={};
str_disp{1} = 'linear';
str_disp{2} = 'quadratic';
set(handles.pop_menu_disc_type,'String',str_disp);

% initialize values
handles.domodel = 0;
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2
    if strcmp(model_loaded.type,'qda')
        set(handles.pop_menu_disc_type,'Value',2);
    else
        set(handles.pop_menu_disc_type,'Value',1);
    end
end

% enable/disable combo
handles = enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings_da);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_da_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    w = get(handles.pop_menu_cv_groups,'Value');
    cv_groups = get(handles.pop_menu_cv_groups,'String');
    cv_groups = cv_groups{w};
    cv_groups = str2num(cv_groups);
    varargout{1} = cv_groups;
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
    varargout{2} = set_this;
    if get(handles.pop_menu_disc_type,'Value') == 1
        set_this = 'lda';
    else
        set_this = 'qda';
    end
    varargout{3} = set_this;
    varargout{4} = handles.domodel;
    delete(handles.visualize_settings_da)
else
    handles.settings.cv_groups = NaN;
    handles.settings.cv_type = NaN;
    handles.settings.disc = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.cv_groups;
    varargout{2} = handles.settings.cv_type;
    varargout{3} = handles.settings.disc;
    varargout{4} = handles.domodel;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_da)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_da)

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

% --- Executes during object creation, after setting all properties.
function pop_menu_disc_type_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_disc_type.
function pop_menu_disc_type_Callback(hObject, eventdata, handles)

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
    set(handles.text7,'String','number of cv groups:');
    set(handles.pop_menu_cv_groups,'String',str_disp);
    set(handles.pop_menu_cv_groups,'Value',5);
else
    cv_group(1) = 100;
    cv_group(2) = 500;
    cv_group(3) = 1000;
    for j=1:length(cv_group)
        str_disp{j} = cv_group(j);
    end
    set(handles.text7,'String','number of iterations:');
    set(handles.pop_menu_cv_groups,'String',str_disp);
    set(handles.pop_menu_cv_groups,'Value',3);
end