function varargout = visualize_profiles(varargin)

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
                   'gui_OpeningFcn', @visualize_profiles_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_profiles_OutputFcn, ...
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

% --- Executes just before visualize_profiles is made visible.
function visualize_profiles_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[102.4286 27.8824 186.1429 31.5882]);
set(handles.visualize_profiles,'Position',[102.4286 27.8824 186.1429 31.5882]);
set(handles.text2,'Position',[36 29.3382 14.1429 1.0588]);
set(handles.text1,'Position',[2.8571 29.3382 16.1429 1.0588]);
set(handles.pop_scaling,'Position',[36 27.1029 27.7143 2.1176]);
set(handles.pop_profiles,'Position',[2.8571 27.1029 28 2.1176]);
set(handles.plot_scaled,'Position',[108.7143 3.7059 73.1429 22.5294]);
set(handles.plot_raw,'Position',[16.8571 3.7059 73.2857 22.5294]);
set(handles.output,'Position',[102.4286 27.8824 186.1429 31.5882]);
movegui(handles.visualize_profiles,'center')
handles.data = varargin{1};
handles.class = varargin{2};
handles.var_labels = varargin{3};

% init scaling combo
% set scaling combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'mean centering';
str_disp{3} = 'autoscaling';
str_disp{4} = 'range scaling';
set(handles.pop_scaling,'String',str_disp);
set(handles.pop_scaling,'Value',3);

% init profiles combo
str_disp={};
str_disp{1} = 'samples';
str_disp{2} = 'average';
set(handles.pop_profiles,'String',str_disp);
set(handles.pop_profiles,'Value',2);

update_plot(handles);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_profiles_OutputFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_profiles_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_profiles.
function pop_profiles_Callback(hObject, eventdata, handles)
update_plot(handles)

% --- Executes during object creation, after setting all properties.
function pop_scaling_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_scaling.
function pop_scaling_Callback(hObject, eventdata, handles)
update_plot(handles)

% -------------------------------------------------------------------------
function update_plot(handles)
data_raw = handles.data;
if get(handles.pop_scaling,'Value') == 1
    pret_type = 'none';
elseif get(handles.pop_scaling,'Value') == 2
    pret_type = 'cent';
elseif get(handles.pop_scaling,'Value') == 3
    pret_type = 'auto';
else
    pret_type = 'rang';
end
data_scaled = data_pretreatment(data_raw,pret_type);
% plot raw data
axes(handles.plot_raw);
cla;
if get(handles.pop_profiles,'Value') == 1 % samples
    plot_samples(data_raw,handles.class,handles.var_labels,'raw data')
else % average
    plot_mean(data_raw,handles.class,handles.var_labels,'raw data')
end
% plot scaled data
axes(handles.plot_scaled);
cla;
if get(handles.pop_profiles,'Value') == 1 % samples
    plot_samples(data_scaled,handles.class,handles.var_labels,'scaled data')
else % average
    plot_mean(data_scaled,handles.class,handles.var_labels,'scaled data')
end

% -------------------------------------------------------------------------
function plot_mean(X,class,variable_labels,add_ylabel)
col_ass = visualize_colors;
if length(class) == 0
    P = mean(X);
else
    for g=1:max(class)
        in = find(class == g);
        P(g,:) = mean(X(in,:));
    end
end
hold on
if length(class) == 0
    plot(P,'Color','r')
    if size(P,2) < 20
        plot(P,'o','MarkerEdgeColor','k','MarkerFaceColor','r')
    end
else
    for g=1:max(class)
        color_in = col_ass(g+1,:);
        str_legend{g} = ['class ' num2str(g)];
        plot(P(g,:),'Color',color_in)
    end
    if size(P,2) < 20
        for g=1:max(class)
            color_in = col_ass(g+1,:);
            plot(P(g,:),'o','MarkerEdgeColor','k','MarkerFaceColor',color_in)
        end
    end
    legend(str_legend)
end
hold off
box on
xlabel('variables')
ylabel(['average - ' add_ylabel])
range_y = max(max(P)) - min(min(P)); 
add_space_y = range_y/20;
y_lim = [min(min(P))-add_space_y max(max(P))+add_space_y];
if y_lim(1) == y_lim(2)
    y_lim(1) = -1;
    y_lim(2) = 1;
end
axis([0.5 size(P,2)+0.5 y_lim(1) y_lim(2)])
if size(P,2) < 20
    set(gca,'XTick',[1:size(P,2)])
    if length(variable_labels) > 0
        set(gca,'XTickLabel',variable_labels)
    end
end

% -------------------------------------------------------------------------
function plot_samples(X,class,variable_labels,add_ylabel)
col_ass = visualize_colors;
hold on
if length(class) == 0
    plot(X','Color','r')
else
    for g=1:max(class) % plot first sample of each class
        in = find(class==g); in = in(1);
        color_in = col_ass(g+1,:);
        str_legend{g} = ['class ' num2str(g)];
        plot(X(in,:)','Color',color_in)
    end
    legend(str_legend)
    for g=1:max(class) % plot other samples of each class
        in = find(class==g); in = in(2:end);
        color_in = col_ass(g+1,:);
        plot(X(in,:)','Color',color_in)
    end
end
hold off
box on
xlabel('variables')
ylabel(['samples - ' add_ylabel])
range_y = max(max(X)) - min(min(X)); 
add_space_y = range_y/20;
y_lim = [min(min(X))-add_space_y max(max(X))+add_space_y];
if y_lim(1) == y_lim(2)
    y_lim(1) = -1;
    y_lim(2) = 1;
end
axis([0.5 size(X,2)+0.5 y_lim(1) y_lim(2)])
if size(X,2) < 20
    set(gca,'XTick',[1:size(X,2)])
    if length(variable_labels) > 0
        set(gca,'XTickLabel',variable_labels)
    end
end
