function varargout = visualize_predict_samples(varargin)

% visualize_predict_samples opens a graphical interface for visualizing
% results achieved in the gui procedure.
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
                   'gui_OpeningFcn', @visualize_predict_samples_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_predict_samples_OutputFcn, ...
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


% --- Executes just before visualize_predict_samples is made visible.
function visualize_predict_samples_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 44.2941 74 15.1765]);
set(handles.visualize_predict_samples,'Position',[103.8571 44.2941 74 15.1765]);
set(handles.button_view_cm,'Position',[42.2 6.5385 26.4 1.7692]);
set(handles.button_class_calc,'Position',[42 4.2308 26.6 1.7692]);
set(handles.pred_listbox_param,'Position',[4 2.3846 35.4 6]);
set(handles.pred_text_error,'Position',[4 8.6154 34 4.6154]);
set(handles.text1,'Position',[4 13.5385 30.6 1.2308]);
set(handles.frame1,'Position',[1.2 1.3846 70.4 12.5385]);
set(handles.output,'Position',[103.8571 44.2941 74 15.1765]);
movegui(handles.visualize_predict_samples,'center');
handles.class_param = varargin{1};
handles.class_pred = varargin{2};
% enable/disable and update
handles = update_pred(handles);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_predict_samples_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function pred_listbox_param_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pred_listbox_param.
function pred_listbox_param_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_class_calc.
function button_class_calc_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.class_pred);
openvar('tmp_view');

% --- Executes on button press in button_view_cm.
function button_view_cm_Callback(hObject, eventdata, handles)
class_param = handles.class_param;
conf_mat = class_param.conf_mat;
assignin('base','tmp_view',conf_mat);
openvar('tmp_view');

% -------------------------------------------------------------------------
function handles = update_pred(handles)

class_param = handles.class_param;

nformat2 = '%1.2f';
hr  = sprintf('\n');
hspace = '       ';
er  = sprintf(nformat2,class_param.er);
ner = sprintf(nformat2,class_param.ner);    
na  = sprintf(nformat2,class_param.not_ass);
ac  = sprintf(nformat2,class_param.accuracy);
na_num = class_param.not_ass;
sp  = class_param.specificity;
sn  = class_param.sensitivity;
pr  = class_param.precision;
num_class = length(sp);

% error rates
str_er{1} = ['error rate: ' er];
str_er{2} = ['non-error rate: ' ner];
str_er{3} = ['accuracy: ' ac];
if na_num > 0
    str_er{4} = ['not-assigned: ' na];
end

% Specificity & Co.
str_sp{1} = ['class' '   ' 'Spec' '      ' 'Sens' '      ' 'Prec'];
for k=1:num_class
    str_sp{k + 1} = ['  ' num2str(k)];
    sp_in = sprintf(nformat2,sp(k));
    sn_in = sprintf(nformat2,sn(k));
    pr_in = sprintf(nformat2,pr(k));
    str_sp{k + 1} = [str_sp{k + 1} hspace sp_in hspace sn_in hspace pr_in];
end

set(handles.pred_text_error,'String',str_er);
set(handles.pred_listbox_param,'String',str_sp);
