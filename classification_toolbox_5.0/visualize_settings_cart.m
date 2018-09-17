function varargout = visualize_settings_cart(varargin)

% visualize_settings_cart opens a graphical interface for prepearing
% settings of CART
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
                   'gui_OpeningFcn', @visualize_settings_cart_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_cart_OutputFcn, ...
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


% --- Executes just before visualize_settings_cart is made visible.
function visualize_settings_cart_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 48.2941 56.7143 11.1765]);
set(handles.visualize_settings_cart,'Position',[103.8571 48.2941 56.7143 11.1765]);
set(handles.text16,'Position',[5 7.8462 22.8 1.1538]);
set(handles.pop_menu_cv_type,'Position',[4.8 6.1538 26.6 1.6923]);
set(handles.text7,'Position',[4.8 4.2308 22.8 1.1538]);
set(handles.text3,'Position',[4 9.3846 9.8 1.1538]);
set(handles.pop_menu_cv_groups,'Position',[4.8 2.4615 26.8 1.6923]);
set(handles.button_cancel,'Position',[37 5.4615 17.6 1.7692]);
set(handles.button_calculate_model,'Position',[37 7.9231 17.2 1.7692]);
set(handles.frame1,'Position',[2.4 1 32.4 8.6923]);
set(handles.output,'Position',[103.8571 48.2941 56.7143 11.1765]);
movegui(handles.visualize_settings_cart,'center')
handles.num_samples = varargin{1};

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

% initialize values
handles.domodel = 0;

% enable/disable combo
handles = enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings_cart);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_cart_OutputFcn(hObject, eventdata, handles)
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
    varargout{3} = handles.domodel;
    delete(handles.visualize_settings_cart)
else
    handles.settings.cv_groups = NaN;
    handles.settings.cv_type = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.cv_groups;
    varargout{2} = handles.settings.cv_type;
    varargout{3} = handles.domodel;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_cart)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_cart)

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


