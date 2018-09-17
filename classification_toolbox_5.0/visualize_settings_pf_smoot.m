function varargout = visualize_settings_pf_smoot(varargin)

% visualize_settings_pf_smoot opens a graphical interface for prepearing
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
                   'gui_OpeningFcn', @visualize_settings_pf_smoot_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_pf_smoot_OutputFcn, ...
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
function visualize_settings_pf_smoot_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[129.7143 34.6471 58.7143 24.8235]);
set(handles.visualize_settings_pf_smoot,'Position',[129.7143 34.6471 58.7143 24.8235]);
set(handles.text20,'Position',[5.7143 14.3382 26.4286 1.1176]);
set(handles.pop_percentiles,'Position',[5.5714 12.5882 27 1.7059]);
set(handles.text19,'Position',[5.7143 17.95 22.8571 1.1176]);
set(handles.pop_kernel,'Position',[5.5714 16.0588 27 1.7059]);
set(handles.pop_menu_cv_type,'Position',[5.5714 5.6471 27 1.7059]);
set(handles.pop_menu_cv_groups,'Position',[5.5714 2.0588 27 1.7059]);
set(handles.text18,'Position',[5.7143 7.3382 22.8571 1.1176]);
set(handles.text17,'Position',[5.7143 3.8088 22.8571 1.1176]);
set(handles.text16,'Position',[5.7143 21.4206 22.8571 1.1176]);
set(handles.pop_menu_scaling,'Position',[5.5714 19.5294 27 1.7059]);
set(handles.text7,'Position',[5.7143 10.8088 27.8571 1.1176]);
set(handles.text3,'Position',[4.5 22.9681 12.25 1.4423]);
set(handles.pop_menu_numcomp,'Position',[5.5714 9.1176 27 1.7059]);
set(handles.button_cancel,'Position',[39 18.629 17 1.8]);
set(handles.button_calculate_model,'Position',[39 21.7059 17 1.8]);
set(handles.frame1,'Position',[2.5714 1.1765 33.1429 22.3529]);
set(handles.output,'Position',[129.7143 34.6471 58.7143 24.8235]);
movegui(handles.visualize_settings_pf_smoot,'center')
handles.model_is_present = varargin{1};
model_loaded = varargin{2};
handles.num_samples = varargin{3};

% set cv type combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'venetian blinds cross validation';
str_disp{3} = 'contiguous blocks cross validation';
set(handles.pop_menu_cv_type,'String',str_disp);

% set cv groups combo
str_disp={};
cv_group(1) = 2;
cv_group(2) = 3;
cv_group(3) = 4;
cv_group(4) = 5;
cv_group(5) = 10;
cv_group(6) = handles.num_samples;
for j=1:length(cv_group)
    str_disp{j} = cv_group(j);
end
set(handles.pop_menu_cv_groups,'String',str_disp);
set(handles.pop_menu_cv_groups,'Value',5);

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
set(handles.pop_kernel,'String',str_disp);

% set percentile combo
str_disp={};
perc_list(1) = 80;
perc_list(2) = 90;
perc_list(3) = 95;
perc_list(4) = 99;
for j=1:length(perc_list)
    str_disp{j} = perc_list(j);
end
set(handles.pop_percentiles,'String',str_disp);
set(handles.pop_percentiles,'Value',3);

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
            set(handles.pop_kernel,'Value',1);
        else
            set(handles.pop_kernel,'Value',2);
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
        set(handles.pop_percentiles,'Value',set_this);
    else
        set(handles.pop_menu_scaling,'Value',3);
        set(handles.pop_menu_numcomp,'Value',1);
    end
else
    set(handles.pop_menu_scaling,'Value',3);
    set(handles.pop_menu_numcomp,'Value',1);
end

% enable/disable combo
handles = enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings_pf_smoot);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_pf_smoot_OutputFcn(hObject, eventdata, handles)
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
    if get(handles.pop_menu_cv_groups,'Value') == 1
        cv_groups = 2;
    elseif get(handles.pop_menu_cv_groups,'Value') == 2
        cv_groups = 3;
    elseif get(handles.pop_menu_cv_groups,'Value') == 3
        cv_groups = 4;
    elseif get(handles.pop_menu_cv_groups,'Value') == 4
        cv_groups = 5;
    elseif get(handles.pop_menu_cv_groups,'Value') == 5
        cv_groups = 10;
    else
        cv_groups = handles.num_samples;
    end
    varargout{3} = cv_groups;
    if get(handles.pop_menu_cv_type,'Value') == 1
        set_this = 'none';
    elseif get(handles.pop_menu_cv_type,'Value') == 2
        set_this = 'vene';
    else
        set_this = 'cont'; 
    end
    varargout{4} = set_this;
    varargout{5} = handles.domodel;
    if get(handles.pop_kernel,'Value')  == 1
        varargout{6} = 'gaus';
    else
        varargout{6} = 'tria';
    end
    perchere = get(handles.pop_percentiles,'String');
    perchere = perchere(get(handles.pop_percentiles,'Value'));
    perchere = str2num(perchere{1});
    varargout{7} = perchere;
    delete(handles.visualize_settings_pf_smoot)
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
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_pf_smoot)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_pf_smoot)

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

% --- Executes on selection change in pop_percentiles.
function pop_percentiles_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_percentiles_CreateFcn(hObject, eventdata, handles)
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
