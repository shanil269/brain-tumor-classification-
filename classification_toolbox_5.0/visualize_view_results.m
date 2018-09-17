function varargout = visualize_view_results(varargin)

% visualize_view_results opens a graphical interface for visualizing
% results achieved in the classification procedure
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
                   'gui_OpeningFcn', @visualize_view_results_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_view_results_OutputFcn, ...
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


% --- Executes just before visualize_view_results is made visible.
function visualize_view_results_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 31.2941 73.7143 28.1765]);
set(handles.view_results,'Position',[103.8571 31.2941 73.7143 28.1765]);
set(handles.cv_button_view_cm,'Position',[42.2 6.2308 26.4 1.7692]);
set(handles.cv_button_class_calc,'Position',[41.8 3.9231 26.6 1.7692]);
set(handles.cv_listbox_param,'Position',[3.8 2.0769 35.4 6]);
set(handles.cv_text_error,'Position',[4 8.1538 22.4 4.6154]);
set(handles.text3,'Position',[4 13.1538 10.6 1.1538]);
set(handles.frame2,'Position',[1.2 1.0769 68.8 12.5385]);
set(handles.button_view_cm,'Position',[42.2 19.6923 26.4 1.7692]);
set(handles.button_class_calc,'Position',[42 17.3846 26.6 1.7692]);
set(handles.fit_listbox_param,'Position',[4 15.5385 35.4 6]);
set(handles.fit_text_error,'Position',[4.2 21.7692 22.6 4.6154]);
set(handles.text1,'Position',[4 26.4615 7 1.3077]);
set(handles.frame1,'Position',[1.2 14.6923 68.8 12.3077]);
set(handles.output,'Position',[103.8571 31.2941 73.7143 28.1765]);
movegui(handles.view_results,'center');
handles.model = varargin{1};
handles.cv = handles.model.cv;
handles = update_fitting(handles);

% enable/disable
handles = enable_disable(handles);
handles = update_cv(handles);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_view_results_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function fit_listbox_param_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in fit_listbox_param.
function fit_listbox_param_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_class_calc.
function button_class_calc_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.model.class_calc);
openvar('tmp_view');

% --- Executes on button press in button_view_cm.
function button_view_cm_Callback(hObject, eventdata, handles)
conf_mat = print_conf_mat(handles.model.class_param.conf_mat);
assignin('base','tmp_view',conf_mat);
openvar('tmp_view');

% --- Executes during object creation, after setting all properties.
function cv_listbox_param_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in cv_listbox_param.
function cv_listbox_param_Callback(hObject, eventdata, handles)

% --- Executes on button press in cv_button_class_calc.
function cv_button_class_calc_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.cv.class_pred);
openvar('tmp_view');

% --- Executes on button press in cv_button_view_cm.
function cv_button_view_cm_Callback(hObject, eventdata, handles)
conf_mat = print_conf_mat(handles.cv.class_param.conf_mat);
assignin('base','tmp_view',conf_mat);
openvar('tmp_view');

% -------------------------------------------------------------------------
function handles = enable_disable(handles);
if isstruct(handles.cv)
    set(handles.cv_button_view_cm,'Enable','on')
    set(handles.cv_button_class_calc,'Enable','on')
else
    set(handles.cv_button_view_cm,'Enable','off')
    set(handles.cv_button_class_calc,'Enable','off')  
end

% -------------------------------------------------------------------------
function handles = update_cv(handles)
if isstruct(handles.cv)
    nformat2 = '%1.2f';
    hr  = sprintf('\n');
    hspace = '       ';
    er  = sprintf(nformat2,handles.cv.class_param.er);
    ner = sprintf(nformat2,handles.cv.class_param.ner);    
    na  = sprintf(nformat2,handles.cv.class_param.not_ass);
    ac  = sprintf(nformat2,handles.cv.class_param.accuracy);
    na_num = handles.cv.class_param.not_ass;
    sp  = handles.cv.class_param.specificity;
    sn  = handles.cv.class_param.sensitivity;
    pr  = handles.cv.class_param.precision;
    num_class = max(handles.model.settings.class);

    % error rates
    str_er{1} = ['error rate: ' er];
    str_er{2} = ['non-error rate: ' ner];
    str_er{3} = ['accuracy: ' ac];
    if na_num > 0
        str_er{4} = ['not-assigned: ' na];
    end
    set(handles.cv_text_error,'String',str_er);
        
    % Specificity & Co.
    str_sp{1} = ['class' '   ' 'Spec' '      ' 'Sens' '      ' 'Prec'];
    for k=1:num_class
        str_sp{k + 1} = ['  ' num2str(k)];
        sp_in = sprintf(nformat2,sp(k));
        sn_in = sprintf(nformat2,sn(k));
        pr_in = sprintf(nformat2,pr(k));
        str_sp{k + 1} = [str_sp{k + 1} hspace sp_in hspace sn_in hspace pr_in];
    end

    set(handles.cv_listbox_param,'String',str_sp);
else
    str_er = 'not calculated';
    str_sp = '';
    set(handles.cv_text_error,'String',str_er);
    set(handles.cv_listbox_param,'String',str_sp);
end

% -------------------------------------------------------------------------
function handles = update_fitting(handles)

nformat2 = '%1.2f';
hr  = sprintf('\n');
hspace = '       ';
er  = sprintf(nformat2,handles.model.class_param.er);
ner = sprintf(nformat2,handles.model.class_param.ner);    
na  = sprintf(nformat2,handles.model.class_param.not_ass);
ac = sprintf(nformat2,handles.model.class_param.accuracy);
na_num = handles.model.class_param.not_ass;
sp  = handles.model.class_param.specificity;
sn  = handles.model.class_param.sensitivity;
pr  = handles.model.class_param.precision;
num_class = max(handles.model.settings.class);

% error rates
str_er{1} = ['error rate: ' er];
str_er{2} = ['non-error rate: ' ner];
str_er{3} = ['accuracy: ' ac];
if na_num > 0
    str_er{4} = ['not-assigned: ' na];
end
set(handles.fit_text_error,'String',str_er);

% Specificity & Co.
str_sp{1} = ['class' '   ' 'Spec' '      ' 'Sens' '      ' 'Prec'];
for k=1:num_class
    str_sp{k + 1} = ['  ' num2str(k)];
    sp_in = sprintf(nformat2,sp(k));
    sn_in = sprintf(nformat2,sn(k));
    pr_in = sprintf(nformat2,pr(k));
    str_sp{k + 1} = [str_sp{k + 1} hspace sp_in hspace sn_in hspace pr_in];
end

set(handles.fit_listbox_param,'String',str_sp);

% -------------------------------------------------------------------------
function S = print_conf_mat(conf_mat);

S{1,1} = 'real/predicted';
for g=1:size(conf_mat,1)
    S{1,g+1} = ['class ' num2str(g)];    
end
S{1,size(conf_mat,1) + 2}=['not assigned']; 
for g=1:size(conf_mat,1)
    S{g+1,1} = ['class ' num2str(g)]; 
    for k=1:size(conf_mat,2)
        S{g+1,k+1} = num2str(conf_mat(g,k));    
    end
end
