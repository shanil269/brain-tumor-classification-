function varargout = visualize_settings_simca(varargin)

% visualize_settings_simca opens a graphical interface for prepearing
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
                   'gui_OpeningFcn', @visualize_settings_simca_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_simca_OutputFcn, ...
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


% --- Executes just before visualize_settings_simca is made visible.
function visualize_settings_simca_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 37.8824 86.1429 21.5882]);
set(handles.visualize_settings_simca,'Position',[103.8571 37.8824 86.1429 21.5882]);
set(handles.text23,'Position',[4.4 3.7692 24.8 1.1538]);
set(handles.pop_menu_numcomp_c5,'Position',[4.4 2 26.8 1.6923]);
set(handles.text22,'Position',[4.4 7.4615 24.8 1.1538]);
set(handles.pop_menu_numcomp_c4,'Position',[4.4 5.6923 26.8 1.6923]);
set(handles.text21,'Position',[4.4 11.0769 24.8 1.1538]);
set(handles.pop_menu_numcomp_c3,'Position',[4.4 9.3077 26.8 1.6923]);
set(handles.text20,'Position',[4.4 14.7692 24.8 1.1538]);
set(handles.pop_menu_numcomp_c2,'Position',[4.4 13 26.8 1.6923]);
set(handles.text19,'Position',[33.4 14.7692 22.8 1.1538]);
set(handles.pop_menu_assignation,'Position',[33.4 13 26.6 1.6923]);
set(handles.pop_menu_cv_type,'Position',[33.4 9.3077 26.6 1.6923]);
set(handles.pop_menu_cv_groups,'Position',[33.4 5.6923 26.8 1.6923]);
set(handles.text18,'Position',[33.4 11.0769 22.8 1.1538]);
set(handles.text17,'Position',[33.4 7.4615 22.8 1.1538]);
set(handles.text16,'Position',[33.4 18.4615 22.8 1.1538]);
set(handles.pop_menu_scaling,'Position',[33.4 16.6923 26.6 1.6923]);
set(handles.text7,'Position',[4.4 18.4615 24.8 1.1538]);
set(handles.text3,'Position',[3.6 20 9.8 1.1538]);
set(handles.pop_menu_numcomp_c1,'Position',[4.4 16.6923 26.8 1.6923]);
set(handles.button_cancel,'Position',[65.8 16.0769 17.6 1.7692]);
set(handles.button_calculate_model,'Position',[65.8 18.5385 17.2 1.7692]);
set(handles.frame1,'Position',[2 1.0769 60.4 19.2308]);
set(handles.output,'Position',[103.8571 37.8824 86.1429 21.5882]);
movegui(handles.visualize_settings_simca,'center')
handles.maxcomp = varargin{1};
handles.model_is_present = varargin{2};
model_loaded = varargin{3};
handles.num_samples = varargin{4};
handles.num_classes = varargin{5};
handles.method_name = varargin{6};
set(handles.visualize_settings_simca,'Name',[handles.method_name ' settings']);

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

% set assignation combo
str_disp={};
str_disp{1} = 'class modeling';
str_disp{2} = 'dist';
set(handles.pop_menu_assignation,'String',str_disp);

% initialize values
handles.domodel = 0;
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2
    if strcmp(model_loaded.type,'simca') && strcmp(handles.method_name,'SIMCA')
        if strcmp(model_loaded.settings.pret_type,'none')
            set_this = 1;
        elseif strcmp(model_loaded.settings.pret_type,'cent')
            set_this = 2;
        else
            set_this = 3;
        end
        set(handles.pop_menu_scaling,'Value',set_this);
        for g = 1:length(model_loaded.T); num_comp(g) = size(model_loaded.T{g},2); end 
        handles = setcomp_in_combo(handles,num_comp);
        if strcmp(model_loaded.settings.assign_method,'dist')
            set(handles.pop_menu_assignation,'Value',2);
        else
            set(handles.pop_menu_assignation,'Value',1);
        end
    elseif strcmp(model_loaded.type,'uneq') && strcmp(handles.method_name,'UNEQ')
        if strcmp(model_loaded.settings.pret_type,'none')
            set_this = 1;
        elseif strcmp(model_loaded.settings.pret_type,'cent')
            set_this = 2;
        else
            set_this = 3;
        end
        set(handles.pop_menu_scaling,'Value',set_this);
        for g = 1:length(model_loaded.T); num_comp(g) = size(model_loaded.T{g},2); end 
        handles = setcomp_in_combo(handles,num_comp);
        if strcmp(model_loaded.settings.assign_method,'dist')
            set(handles.pop_menu_assignation,'Value',2);
        else
            set(handles.pop_menu_assignation,'Value',1);
        end
    else
        set(handles.pop_menu_scaling,'Value',3);
        handles = setcomp_in_combo(handles,ones(handles.num_classes,1)*handles.maxcomp);
    end
else
    set(handles.pop_menu_scaling,'Value',3);
    handles = setcomp_in_combo(handles,ones(handles.num_classes,1)*handles.maxcomp);
end

% enable/disable combo
handles = enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings_simca);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_simca_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    varargout{1} = getcomp_from_combo(handles);
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
        varargout{6} = 'class modeling';
    else
        varargout{6} = 'dist';
    end
    delete(handles.visualize_settings_simca)
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
uiresume(handles.visualize_settings_simca)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_simca)

% --- Executes during object creation, after setting all properties.
function pop_menu_numcomp_c1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_numcomp_c1.
function pop_menu_numcomp_c1_Callback(hObject, eventdata, handles)

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
if handles.num_classes < 5
    set(handles.pop_menu_numcomp_c5,'Enable','off');
    set(handles.pop_menu_numcomp_c5,'String','no class');
else
    set(handles.pop_menu_numcomp_c5,'Enable','on');
end
if handles.num_classes < 4
    set(handles.pop_menu_numcomp_c4,'Enable','off');
    set(handles.pop_menu_numcomp_c4,'String','no class');
else
    set(handles.pop_menu_numcomp_c4,'Enable','on');
end
if handles.num_classes < 3
    set(handles.pop_menu_numcomp_c3,'Enable','off');
    set(handles.pop_menu_numcomp_c3,'String','no class');
else
    set(handles.pop_menu_numcomp_c3,'Enable','on');
end

% ------------------------------------------------------------------------
function handles = setcomp_in_combo(handles,num_comp)
str_disp={};
for j=1:handles.maxcomp
    str_disp{j} = num2str(j);
end
for g=1:length(num_comp)
    if g == 1
        set(handles.pop_menu_numcomp_c1,'String',str_disp);
        set(handles.pop_menu_numcomp_c1,'Value',num_comp(g));
    elseif g == 2
        set(handles.pop_menu_numcomp_c2,'String',str_disp);
        set(handles.pop_menu_numcomp_c2,'Value',num_comp(g));
    elseif g == 3
        set(handles.pop_menu_numcomp_c3,'String',str_disp);
        set(handles.pop_menu_numcomp_c3,'Value',num_comp(g));
    elseif g == 4
        set(handles.pop_menu_numcomp_c4,'String',str_disp);
        set(handles.pop_menu_numcomp_c4,'Value',num_comp(g));
    elseif g == 5
        set(handles.pop_menu_numcomp_c5,'String',str_disp);
        set(handles.pop_menu_numcomp_c5,'Value',num_comp(g));
    end
end

% ------------------------------------------------------------------------
function num_comp = getcomp_from_combo(handles)
for g=1:handles.num_classes
    if g == 1
        num_comp(g) = get(handles.pop_menu_numcomp_c1,'Value');
    elseif g == 2
        num_comp(g) = get(handles.pop_menu_numcomp_c2,'Value');
    elseif g == 3
        num_comp(g) = get(handles.pop_menu_numcomp_c3,'Value');
    elseif g == 4
        num_comp(g) = get(handles.pop_menu_numcomp_c4,'Value');
    elseif g == 5
        num_comp(g) = get(handles.pop_menu_numcomp_c5,'Value');
    end
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

% --- Executes during object creation, after setting all properties.
function pop_menu_numcomp_c2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_numcomp_c2.
function pop_menu_numcomp_c2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_numcomp_c3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_numcomp_c3.
function pop_menu_numcomp_c3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_numcomp_c4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_numcomp_c4.
function pop_menu_numcomp_c4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_numcomp_c5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_numcomp_c5.
function pop_menu_numcomp_c5_Callback(hObject, eventdata, handles)

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