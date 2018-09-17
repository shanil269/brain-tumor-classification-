function varargout = visualize_export(varargin)

% visualize_export opens a graphical interface for saving variables to the
% workspace
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
                   'gui_OpeningFcn', @visualize_export_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_export_OutputFcn, ...
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


% --- Executes just before visualize_export is made visible.
function visualize_export_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 52.5294 56.1429 6.9412]);
set(handles.visualize_export,'Position',[103.8571 52.5294 56.1429 6.9412]);
set(handles.cancel_button,'Position',[35 1 15 1.7692]);
set(handles.save_button,'Position',[4.4 1 15.6 1.7692]);
set(handles.variable_name_text,'Position',[3.2 3.3846 48.8 1.5385]);
set(handles.text1,'Position',[3.4 5 47.4 1.1538]);
set(handles.output,'Position',[103.8571 52.5294 56.1429 6.9412]);
movegui(handles.visualize_export,'center');
guidata(hObject, handles);

% set data to be saved
handles.output = varargin{1};
type    = varargin{2};

if strcmp (type,'model')
    set(handles.variable_name_text,'String','model_name')
elseif strcmp (type,'cv')
    set(handles.variable_name_text,'String','cv_name')
elseif strcmp (type,'settings')
    set(handles.variable_name_text,'String','settings_name')
elseif strcmp (type,'cluster')
    set(handles.variable_name_text,'String','cluster_name')
elseif strcmp (type,'pred')
    set(handles.variable_name_text,'String','pred_name')    
end
guidata(hObject, handles);
uiwait(handles.visualize_export);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_export_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    varargout{1} = handles.output;
    delete(handles.visualize_export)
else
    handles.output = NaN;
    varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function variable_name_text_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function variable_name_text_Callback(hObject, eventdata, handles)

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
variable_name = get(handles.variable_name_text,'String');
if length(variable_name) > 0
    assignin('base',variable_name,handles.output)
end
guidata(hObject, handles);
uiresume(handles.visualize_export)

% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
uiresume(handles.visualize_export)
