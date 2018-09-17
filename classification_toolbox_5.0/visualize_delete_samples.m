function varargout = visualize_delete_samples(varargin)

% visualize_delete_samples opens a graphical interface for deleting samples
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
                   'gui_OpeningFcn', @visualize_delete_samples_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_delete_samples_OutputFcn, ...
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


% --- Executes just before visualize_delete_samples is made visible.
function visualize_delete_samples_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 48.2941 56.1429 11.1765]);
set(handles.visualize_delete_samples,'Position',[103.8571 48.2941 56.1429 11.1765]);
set(handles.txt_sample,'Position',[2.6 3.3077 47.4 3.9231]);
set(handles.text2,'Position',[2.6 9.0769 14 1.2308]);
set(handles.pop_samples,'Position',[19.2 8.6923 18.2 1.6923]);
set(handles.cancel_button,'Position',[3 0.76923 15 1.7692]);
set(handles.delete_button,'Position',[36.4 0.76923 15.6 1.7692]);
set(handles.text1,'Position',[2.6 7.1538 47.4 1.1538]);
set(handles.output,'Position',[103.8571 48.2941 56.1429 11.1765]);
movegui(handles.visualize_delete_samples,'center');
guidata(hObject, handles);

% set data to be saved
handles.num_samples = varargin{1};
handles.class = varargin{2};
handles.sample_labels = varargin{3};

% init sample combo
if length(handles.sample_labels) == 0
    for j=1:handles.num_samples; sample_labels{j} = ['sample ' num2str(j)]; end
else
    sample_labels = handles.sample_labels;
end
str_disp={};
for j=1:length(sample_labels)
    str_disp{j} = sample_labels{j};
end
set(handles.pop_samples,'String',str_disp);
set(handles.pop_samples,'Value',1);
handles = update_txtsample(handles);
guidata(hObject, handles);
uiwait(handles.visualize_delete_samples);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_delete_samples_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    if handles.do_delete
        sample_out = get(handles.pop_samples,'Value');
        varargout{1} = sample_out;
    else
        varargout{1} = NaN;
    end
    delete(handles.visualize_delete_samples)
else
    varargout{1} = NaN;
end

% --- Executes on button press in delete_button.
function delete_button_Callback(hObject, eventdata, handles)
handles.do_delete = 1;
guidata(hObject, handles);
uiresume(handles.visualize_delete_samples)

% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
handles.do_delete = 0;
guidata(hObject, handles);
uiresume(handles.visualize_delete_samples)

% --- Executes during object creation, after setting all properties.
function pop_samples_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_samples.
function pop_samples_Callback(hObject, eventdata, handles)
handles = update_txtsample(handles);
guidata(hObject, handles);

% -----------------------------------------------------------
function handles = update_txtsample(handles)
in = get(handles.pop_samples,'Value');
h1 = ['sample id: ' num2str(in)];
if length(handles.class) > 0
    h2 = ['sample class: ' num2str(handles.class(in))];
else
    h2 = ['sample class: not loaded'];
end
if length(handles.sample_labels) > 0
    h3 = ['sample label: ' handles.sample_labels{in}];
else
    h3 = ['sample label: not loaded'];
end
hr = sprintf('\n');
set(handles.txt_sample,'String',[h1 hr h2 hr h3]);