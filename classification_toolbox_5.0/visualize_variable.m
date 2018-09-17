function varargout = visualize_variable(varargin)

% visualize_variable opens a graphical interface for visualizing
% univariate abnd bivariate plots of variables
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
                   'gui_OpeningFcn', @visualize_variable_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_variable_OutputFcn, ...
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

% --- Executes just before visualize_variable is made visible.
function visualize_variable_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 32.1176 120.5714 30.3529]);
set(handles.visualize_variable,'Position',[103.8571 32.1176 120.5714 30.3529]);
set(handles.button_class,'Position',[1.8 15.6154 22.2 1.7692]);
set(handles.chk_legend,'Position',[1.8 18.6923 22 1.1538]);
set(handles.chk_samples,'Position',[1.8 20.6923 22.8 1.1538]);
set(handles.text1,'Position',[1.8 28.2308 10.2 1.1538]);
set(handles.button_export,'Position',[1.8 12.8462 22.2 1.7692]);
set(handles.pop_plot,'Position',[1.8 23.1538 22.2 1.6923]);
set(handles.pop_variable,'Position',[1.8 26.3846 22.4 1.6923]);
set(handles.plot_graph,'Position',[38.6 5.5538 77 23.2308]);
set(handles.output,'Position',[103.8571 32.1176 120.5714 30.3529]);
movegui(handles.visualize_variable,'center')
handles.data = varargin{1};
handles.class = varargin{2};
handles.var_labels = varargin{3};
handles.sample_labels = varargin{4};
if length(handles.sample_labels) == 0
    for j=1:size(handles.data,1); lab_sample{j} = num2str(j); end
    handles.sample_labels = lab_sample;
end

% init variable combo
if length(handles.var_labels) == 0
    for j=1:size(handles.data,2); lab_var{j} = ['var ' num2str(j)]; end
    handles.var_labels = lab_var;
end
str_disp={};
for j=1:length(handles.var_labels)
    str_disp{j} = handles.var_labels{j};
end
set(handles.pop_variable,'String',str_disp);
set(handles.pop_variable,'Value',1);

% init plot combo
str_disp={};
str_disp{1} = 'hist';
str_disp{2} = 'boxplot';
for j=1:length(handles.var_labels)
    str_disp{j+2} = handles.var_labels{j};
end
set(handles.pop_plot,'String',str_disp);
set(handles.pop_plot,'Value',1);

% update plots
update_plot(handles,0);
handles = enable_disable(handles);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_variable_OutputFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_variable_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_variable.
function pop_variable_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% --- Executes during object creation, after setting all properties.
function pop_plot_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_plot.
function pop_plot_Callback(hObject, eventdata, handles)
update_plot(handles,0)
handles = enable_disable(handles);

% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
update_plot(handles,1)

% --- Executes on button press in chk_samples.
function chk_samples_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% --- Executes on button press in chk_legend.
function chk_legend_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% --- Executes on button press in button_class.
function button_class_Callback(hObject, eventdata, handles)
update_plot(handles,2)

% -------------------------------------------------------------------------
function handles = enable_disable(handles);
if length(handles.class) > 0 & get(handles.pop_plot,'Value') > 2
    set(handles.chk_legend,'Enable','on');
else
    set(handles.chk_legend,'Enable','off');
end
if get(handles.pop_plot,'Value') > 2
    set(handles.chk_samples,'Enable','on');
else
    set(handles.chk_samples,'Enable','off');
end
if length(handles.class) > 0 & get(handles.pop_plot,'Value') < 3
    set(handles.button_class,'Enable','on');
else
    set(handles.button_class,'Enable','off');
end
% -------------------------------------------------------------------------
function update_plot(handles,external)

col_ass = visualize_colors;
x = get(handles.pop_variable,'Value');
y = get(handles.pop_plot,'Value');
show_label = get(handles.chk_samples,'Value');
show_legend = get(handles.chk_legend,'Value');
if size(handles.data,1) > 100
    bins = 20;
else
    bins = 10;
end
step = (max(handles.data(:,x)) - min(handles.data(:,x)))/bins;
binhere = [min(handles.data(:,x)):step:max(handles.data(:,x))];
% do raw profiles
if external > 0
    figure; set(gcf,'color','white'); box on;
else
    axes(handles.plot_graph); 
end
cla;
if y == 1
    if external < 2
        hist(handles.data(:,x),binhere)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor',[0.5 0.5 1.0],'EdgeColor','k');
        xlabel(handles.var_labels{x})
    else
        for g=1:max(handles.class)
            subplot(max(handles.class),1,g)
            color_in = col_ass(g+1,:);
            hist(handles.data(find(handles.class==g),x),binhere)
            h = findobj(gca,'Type','patch');
            set(h,'FaceColor',color_in,'EdgeColor','k');
            xlabel([handles.var_labels{x} ' - class ' num2str(g)])
        end
    end
elseif y == 2
    if external < 2
        boxplot(handles.data(:,x))
        xlabel(handles.var_labels{x})
    else
        y_lim(1) = min(min(handles.data(:,x)));
        y_lim(2) = max(max(handles.data(:,x)));
        add_space_y = (y_lim(2) - y_lim(1))/20;
        y_lim(1) = y_lim(1) - add_space_y;
        y_lim(2) = y_lim(2) + add_space_y;
        for g=1:max(handles.class)
            subplot(1,max(handles.class),g)
            boxplot(handles.data(find(handles.class==g),x))
            xlabel([handles.var_labels{x} ' - class ' num2str(g)])
            axis([0.5 1.5 y_lim(1) y_lim(2)])
        end
    end
else
    if length(handles.class) > 0
        hold on
        for g=1:max(handles.class)
            color_in = col_ass(g+1,:);
            plot(handles.data(find(handles.class==g),x),handles.data(find(handles.class==g),y-2),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',color_in)
            legend_label{g} = ['class ' num2str(g)];
        end
        hold off
    else
        plot(handles.data(:,x),handles.data(:,y-2),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor','w')
    end
    y_lim(1) = min(min(handles.data(:,y-2)));
    y_lim(2) = max(max(handles.data(:,y-2)));
    x_lim(1) = min(min(handles.data(:,x)));
    x_lim(2) = max(max(handles.data(:,x)));
    add_space_y = (y_lim(2) - y_lim(1))/20;
    add_space_x = (x_lim(2) - x_lim(1))/20;
    y_lim(1) = y_lim(1) - add_space_y;
    y_lim(2) = y_lim(2) + add_space_y;
    x_lim(1) = x_lim(1) - add_space_x;
    x_lim(2) = x_lim(2) + add_space_x;
    axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
    xlabel(handles.var_labels{x})
    ylabel(handles.var_labels{y-2})
    if show_label
        hold on
        range_span = x_lim(2) - x_lim(1);
        add_span = range_span/100;
        for i=1:size(handles.data,1); text(handles.data(i,x)+add_span,handles.data(i,y-2),handles.sample_labels{i},'Color','k'); end;
        hold off
    end
    if show_legend
        legend(legend_label)
    else
        legend off
    end
end
if external == 1
    if y == 1
        title(['histogram of ' handles.var_labels{x}]);
    elseif y == 2
        title(['boxplot of ' handles.var_labels{x}]);
    else
        title(['biplot of ' handles.var_labels{x} ' and ' handles.var_labels{y-2}]); 
    end
end
box on
