function varargout = visualize_lambda(varargin)

% visualize_lambda opens a graphical interface for analysing wilks lambda 
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
                   'gui_OpeningFcn', @visualize_lambda_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_lambda_OutputFcn, ...
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


% --- Executes just before visualize_lambda is made visible.
function visualize_lambda_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[102.8571 33.7647 165.7143 25.7059]);
set(handles.visualize_lambda,'Position',[102.8571 33.7647 165.7143 25.7059]);
set(handles.noselect_variables_botton,'Position',[3.4 1.4615 24.2 1.7692]);
set(handles.lambda_listbox,'Position',[3.2 10 34.2 10.6923]);
set(handles.open_score_button,'Position',[3.4 21.3077 22 1.8462]);
set(handles.text13,'Position',[3.4 8.3077 36.2 1.1538]);
set(handles.number_var_pop,'Position',[3.6 6.6154 18.2 1.6923]);
set(handles.select_variables_button,'Position',[3.4 4.0769 24.4 1.7692]);
set(handles.pca_title_text,'Position',[3 23.9231 13 1.1538]);
set(handles.frame_pca,'Position',[1.4 0.76923 38.6 23.4615]);
set(handles.score_plot,'Position',[51.6 3.6923 108.4 20.3846]);
set(handles.output,'Position',[102.8571 33.7647 165.7143 25.7059]);
movegui(handles.visualize_lambda,'center');
handles.data = varargin{1};

% initialize combo
str_disp = {};
for k = 1:size(handles.data.X,2);
    str_disp{k} = num2str(k);
end
set(handles.number_var_pop,'String',str_disp);
set(handles.number_var_pop,'Value',size(handles.data.X,2));
handles.select_var = 0;

X = handles.data.X;
class = handles.data.class;
[lambda,rank] = wilks_lambda(X,class);
handles.lambda = lambda;
handles.rank = rank;

update_plot(handles,0);
write_values(handles)
guidata(hObject, handles);
uiwait(handles.visualize_lambda);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_lambda_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    if handles.select_var == 1
        varargout{1} = handles.rank(1:get(handles.number_var_pop,'Value'));
        delete(handles.visualize_lambda)
    else
        varargout{1} = [];
        delete(handles.visualize_lambda)
    end
else
    varargout{1} = [];
end

% --- Executes on button press in open_score_button.
function open_score_button_Callback(hObject, eventdata, handles)
update_plot(handles,1)

% --- Executes on button press in select_variables_button.
function select_var_button_Callback(hObject, eventdata, handles)
handles.select_var = 1;
guidata(hObject,handles)
uiresume(handles.visualize_lambda)

% --- Executes on button press in noselect_variables_botton.
function noselect_variables_botton_Callback(hObject, eventdata, handles)
handles.select_var = 0;
guidata(hObject,handles)
uiresume(handles.visualize_lambda)

% --- Executes during object creation, after setting all properties.
function lambda_listbox_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in lambda_listbox.
function lambda_listbox_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function number_var_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in number_var_pop.
function number_var_pop_Callback(hObject, eventdata, handles)
update_plot(handles,0);

% ---------------------------------------------------------
function update_plot(handles,external)
rank = handles.rank;
lambda = handles.lambda;
num_var_in = get(handles.number_var_pop,'Value');
if external; 
    figure; set(gcf,'color','white'); box on; 
else; 
    axes(handles.score_plot); 
end
cla
bar(lambda)
colormap([0.8 0.8 1])
hold on
bar(lambda(1:num_var_in),'b')
hold off
if length(handles.data.variable_labels) > 0
    variable_labels = handles.data.variable_labels;
else
    for k=1:length(rank); variable_labels{k} = num2str(k); end
end
variable_labels=variable_labels(rank);
set(gca,'xtick',[1:length(variable_labels)]);
set(gca,'xticklabel',variable_labels);
ylabel('Wilks lambda')
xlabel('variables')
box on
str{1,1} = 'variable';
str{1,2} = 'Wilks lambda';
axis([0 length(variable_labels) + 1 0 max(lambda) + max(lambda)/20 ])

% ---------------------------------------------------------
function write_values(handles)

rank = handles.rank;
lambda = handles.lambda;
str{1,1} = 'variable        lambda';
space1 = '               ';
space2 = '                 ';
if length(handles.data.variable_labels) > 0
    variable_labels = handles.data.variable_labels;
else
    for k=1:length(rank); variable_labels{k} = num2str(k); end
end
variable_labels=variable_labels(rank);
for k=1:length(rank)
    if rank(k) < 10
        str{k+1} = [variable_labels{k} space2 num2str(lambda(k))];
    else
        str{k+1} = [variable_labels{k} space1 num2str(lambda(k))];
    end
end
set(handles.lambda_listbox,'String',str);

