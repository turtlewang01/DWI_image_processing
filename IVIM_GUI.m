function varargout = IVIM_GUI(varargin)
% IVIM_GUI MATLAB code for IVIM_GUI.fig
%      IVIM_GUI, by itself, creates a new IVIM_GUI or raises the existing
%      singleton*.
%
%      H = IVIM_GUI returns the handle to a new IVIM_GUI or the handle to
%      the existing singleton*.
%
%      IVIM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVIM_GUI.M with the given input arguments.
%
%      IVIM_GUI('Property','Value',...) creates a new IVIM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IVIM_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IVIM_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IVIM_GUI

% Last Modified by GUIDE v2.5 17-Dec-2017 11:33:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IVIM_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @IVIM_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before IVIM_GUI is made visible.
function IVIM_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IVIM_GUI (see VARARGIN)

% Choose default command line output for IVIM_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using IVIM_GUI.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes IVIM_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IVIM_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes1);
% cla;
% 
% popup_sel_index = get(handles.popupmenu1, 'Value');
% switch popup_sel_index
%     case 1
%         plot(rand(5));
%     case 2
%         plot(sin(1:0.01:25.99));
%     case 3
%         bar(1:.5:10);
%     case 4
%         plot(membrane);
%     case 5
%         surf(peaks);
% end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%      set(hObject,'BackgroundColor','white');
% end
% 
% set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% d = dialog('Position',[300 300 250 150],'Name','About...');
% 
% txt = uicontrol('Parent',d,...
%     'Style','text',...
%     'Position',[20 80 210 40],...
%     'String','This software is written by WANG Youhua and ZHANG Zhiwei. Email:wangyouhua_cq@qq.com');
% 
% btn = uicontrol('Parent',d,...
%     'Position',[85 20 70 25],...
%     'String','Close',...
%     'Callback','delete(gcf)');


% --------------------------------------------------------------------
function File_Load_Callback(hObject, eventdata, handles)
% hObject    handle to File_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_exchange=struct('Image',0,'bval',1,'metadata',0);
[file_type,analysis_numb] = choose_file_type;
if(strcmp(file_type,'DICOM'))
    [num_image,num_slice] = type_DICOM_information;
    [FileName,PathName] = uigetfile('*.*','Select the DICOM file');
    PathName=strcat(PathName,'IM');    
    num_b=floor(num_image/num_slice);
    image_opt.num_image=num_image;
    image_opt.numb=num_b;
    image_opt.bval=[];
    image_opt.patient_name=[];
    
else
    nii_information = type_nii_information;
    [FileName,PathName] = uigetfile('*.nii','Select the nii file');
    image_opt.num_image=[];
    image_opt.numb=[];
    image_opt.bval=nii_information.bval;
    image_opt.patient_name=nii_information.name;
end
[I,bval,metadata]=file_read(file_type,PathName,FileName,analysis_numb,image_opt);
data_exchange.Image=I;
data_exchange.bval=bval;
data_exchange.metadata=metadata;
hObject.UserData = data_exchange;

d = dialog('Units','normalized','Position',[0.45 0.45 0.25 0.20],'Name','Message');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Units','normalized',...
    'Position',[0.30 0.6 0.4 0.2],...
    'FontSize',10,...
    'String','File Read Completion!');

btn = uicontrol('Parent',d,...
    'Units','normalized',...
    'Position',[0.35 0.2 0.3 0.2],...
    'String','Close',...
    'FontSize',10,...
    'Callback','delete(gcf)');




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Author_Callback(hObject, eventdata, handles)
% hObject    handle to Author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d = dialog('Units','Normalized','Position',[0.4 0.4 0.25 0.25],'Name','Author...');

txt = uicontrol('Parent',d,...
    'FontSize',10,...
    'Style','text',...
    'Units','Normalized',...    
    'Position',[0.2 0.2 0.8 0.4],...
    'HorizontalAlignment','left',...
    'String',{'WANG Youhua:wangyouhua_cq@qq.com';'';'ZHANG Zhiwei:21529833@qq.com'});


% --------------------------------------------------------------------
function Version_Callback(hObject, eventdata, handles)
% hObject    handle to Version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d = dialog('Units','Normalized','Position',[0.4 0.4 0.25 0.25],'Name','Version...');

txt = uicontrol('Parent',d,...
    'Style','text',...
    'FontSize',10,...
    'Units','Normalized',...    
    'HorizontalAlignment','left',...
    'Position',[0.4 0.2 0.4 0.4],...
    'String','Version 1.0');


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Measurement_Callback(hObject, eventdata, handles)
% hObject    handle to Measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ROI_Signal_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_Signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','File_Load');
data_exchange=get(h,'UserData');
I=data_exchange.Image;
bval=data_exchange.bval;

h=figure;
BW = roipoly(I(:,:,1));
I=double(I);
nbval=length(bval);
sig_mean=zeros(1,nbval);
for(i=1:nbval)
    I(:,:,i)=I(:,:,i).*BW;
    sig_mean(i)=sum(sum(I(:,:,i)))/sum(sum(BW));
end
temp=sig_mean(end);
sig_mean(2:end)=sig_mean(1:end-1);
sig_mean(1)=temp;
plot(sort(bval,'ascend'),sig_mean);
xlabel('b Value');
ylabel('Signal');


% --------------------------------------------------------------------
function Choose_Slice_Callback(hObject, eventdata, handles)
% hObject    handle to Choose_Slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Method_Callback(hObject, eventdata, handles)
% hObject    handle to Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analysis_method = choose_analysis_method;
hObject.UserData=analysis_method;



   



% --------------------------------------------------------------------
function ROI_Callback(hObject, eventdata, handles)
% hObject    handle to ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Image_Show_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj('Tag','File_Load');
data_exchange = h.UserData;
I=data_exchange.Image;
h_plot=handles.axes_OriPic;
axes(h_plot);
cla;
imagesc(I(:,:,1));
h_plot.Visible='On';
h_plot=handles.text_Ori_Pic;
h_plot.Visible='On';



% --------------------------------------------------------------------
function Image_Rotation_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Partial_b_Callback(hObject, eventdata, handles)
% hObject    handle to Partial_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bval = Partial_B;
set(hObject,'UserData',bval);
h=findobj('Tag','checkbox_PartialB');
set(h,'UserData',bval);
set(h,'Value',1);




% --------------------------------------------------------------------
function Create_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to Create_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj('Tag','File_Load');
data_exchange = h.UserData;
I=data_exchange.Image;
metadata=data_exchange.metadata;
figure
BW = roipoly(I(:,:,1));
ROI_file=strcat('test_BW_',metadata.PatientName.FamilyName,'.mat');
[save_file,save_path] = uiputfile(ROI_file,'Save ROI file');
save(save_file,'BW');
h=findobj('Tag','Load_ROI');
set(h,'UserData',BW);



% --------------------------------------------------------------------
function Load_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to Load_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj('Tag','File_Load');
data_exchange = h.UserData;
metadata=data_exchange.metadata;
[FileName,PathName] = uigetfile('*.mat','ROI File');
BW=load(strcat(PathName,FileName));
BW=BW.BW;
hObject.UserData=BW;


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Opti_Method_Callback(hObject, eventdata, handles)
% hObject    handle to Opti_Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Opti_Bouds_Callback(hObject, eventdata, handles)
% hObject    handle to Opti_Bouds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function F_bound_Callback(hObject, eventdata, handles)
% hObject    handle to F_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function D_bound_Callback(hObject, eventdata, handles)
% hObject    handle to D_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Dstar_bound_Callback(hObject, eventdata, handles)
% hObject    handle to Dstar_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Image_denoise_Callback(hObject, eventdata, handles)
% hObject    handle to Image_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MainDWIDenoising;


% --- Executes on selection change in popupmenu_SolvMethod.
function popupmenu_SolvMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_SolvMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_SolvMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_SolvMethod
idx=hObject.Value;
chose_str=hObject.String;
hObject.UserData=char(chose_str(idx,:));
h1=findobj('Tag','popupmenu_OptiMethod');
h2=findobj('Tag','popupmenu_Dmethod');
if((idx==2)||(idx==6))
    h1.Enable='off';    
else
    h1.Enable='on';    
end

h2=findobj('Tag','popupmenu_Dmethod');
if(idx==2)    
    h2.Enable='off';
else    
    h2.Enable='on';
end

if(idx==5)    
    h2.Enable='off';
else    
    h2.Enable='on';
end

h2=findobj('Tag','edit_DSLB');
if((idx==4)||(idx==2))    
    h2.Enable='off';
else    
    h2.Enable='on';
end

h1=findobj('Tag','edit_DSUB');
if(idx==2)    
    h1.Enable='off';    
else    
    h1.Enable='on';    
end







% --- Executes during object creation, after setting all properties.
function popupmenu_SolvMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_SolvMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Biexp','Simp IVIM','MIX','fix D*','Solve 3 Var Simul','Three-Steps'});



function edit_fLB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fLB as text
%        str2double(get(hObject,'String')) returns contents of edit_fLB as a double
data=str2double(get(hObject,'String'));
set(hObject,'UserData',data);


% --- Executes during object creation, after setting all properties.
function edit_fLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',0);
set(hObject,'UserData',0);



function edit_fUB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fUB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fUB as text
%        str2double(get(hObject,'String')) returns contents of edit_fUB as a double
data=str2double(get(hObject,'String'));
set(hObject,'UserData',data);


% --- Executes during object creation, after setting all properties.
function edit_fUB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fUB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'Value',0.3);
set(hObject,'UserData',0.3);



function edit_DLB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DLB as text
%        str2double(get(hObject,'String')) returns contents of edit_DLB as a double
data=str2double(get(hObject,'String'));
set(hObject,'UserData',data);


% --- Executes during object creation, after setting all properties.
function edit_DLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',0);
set(hObject,'UserData',0);



function edit_DUB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DUB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DUB as text
%        str2double(get(hObject,'String')) returns contents of edit_DUB as a double
data=str2double(get(hObject,'String'))*10^(-3);
set(hObject,'UserData',data);


% --- Executes during object creation, after setting all properties.
function edit_DUB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DUB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',2.5);
set(hObject,'UserData',2.5*10^(-3));



function edit_DSLB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DSLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DSLB as text
%        str2double(get(hObject,'String')) returns contents of edit_DSLB as a double
data=str2double(get(hObject,'String'));
set(hObject,'UserData',data);


% --- Executes during object creation, after setting all properties.
function edit_DSLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DSLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',0);
set(hObject,'UserData',0);



function edit_DSUB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DSUB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DSUB as text
%        str2double(get(hObject,'String')) returns contents of edit_DSUB as a double
data=str2double(get(hObject,'String'))*10^(-3);
set(hObject,'UserData',data);


% --- Executes during object creation, after setting all properties.
function edit_DSUB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DSUB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',50);
set(hObject,'UserData',50*10^(-3));



% --- Executes on selection change in popupmenu_OptiMethod.
function popupmenu_OptiMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_OptiMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_OptiMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_OptiMethod


% --- Executes during object creation, after setting all properties.
function popupmenu_OptiMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_OptiMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'levenberg-marquardt','trust-region-reflective'});


% --- Executes on button press in radiobutton_stdModel.
function radiobutton_stdModel_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_stdModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_stdModel
status=get(hObject,'Value');
h=findobj('Tag','radiobutton_modModel');
if(status)
    h.Value=0;
else
    h.Value=1;
end


% --- Executes on button press in radiobutton_modModel.
function radiobutton_modModel_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_modModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_modModel
status=get(hObject,'Value');
h=findobj('Tag','radiobutton_stdModel');
if(status)
    h.Value=0;
else
    h.Value=1;
end



function edit_NoiseThresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NoiseThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NoiseThresh as text
%        str2double(get(hObject,'String')) returns contents of edit_NoiseThresh as a double
data=str2double(get(hObject,'String'));
set(hObject,'UserData',data);


% --- Executes during object creation, after setting all properties.
function edit_NoiseThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NoiseThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',15);

% --- Executes on button press in pushbutton_calculate.
function pushbutton_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=findobj('Tag','File_Load');
Image_info=get(h,'UserData');
I=Image_info.Image;
b_val=transpose(Image_info.bval);
metadata=Image_info.metadata;
clear Image_info;


h=findobj('Tag','checkbox_PartialB');    
flag_use_part_b=get(h,'Value');

if(flag_use_part_b)    
    h=findobj('Tag','checkbox_PartialB');    
    b_value_list=transpose(get(h,'UserData'));    
    used_index=zeros(size(b_value_list));
    b_value_list=sort(b_value_list,'ascend');
    num_blist=length(b_value_list);    
    for(i=1:num_blist)
        temp=find(abs(b_val-b_value_list(i))<0.5);
        if(isempty(temp))
            error('Wrong number!');
        else
            used_index(i)=temp;
        end
    end
    b_val=[b_value_list,b_val(end)];
    temp=zeros(metadata.Height,metadata.Width,num_blist+1);
    temp(:,:,1:num_blist)=I(:,:,used_index);
    temp(:,:,end)=I(:,:,end);
    I=temp;
    clear temp;
    num_b=length(b_val);
    
    num_start=1; % the 9th b number
    num_end=num_blist; % the 13th b number
else
    num_start=9; % the 9th b number
    num_end=13; % the 13th b number
end
b_val=transpose(b_val);
n_length=num_end-num_start+1;
b_val_nonzero=b_val(1:end-1);

I=double(I);

h=findobj('Tag','Load_ROI');
BW=get(h,'UserData');
if(isempty(BW))
    d = dialog('Units','Normalized','Position',[0.45 0.45 0.25 0.15],'Name','Message');
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Fontsize',10,...
        'Units','Normalized',...
        'HorizontalAlignment','left',...
        'Position',[0.25 0.5 0.45 0.2],...
        'String','Please Create/Load ROI first!');
    
    btn = uicontrol('Parent',d,...
        'Units','Normalized',...
        'Position',[0.4 0.15 0.2 0.2],...
        'Fontsize',10,...
        'String','Close',...
        'Callback','delete(gcf)');
    return;
end
option.BW=BW;
option.num_start=num_start;
option.num_end=num_end;

h=findobj('Tag','popupmenu_SolvMethod');
option.solve_method=get(h,'Value');

h=findobj('Tag','popupmenu_Dmethod');
option.d_method=get(h,'Value');

h=findobj('Tag','radiobutton_modModel');
option.use_modify_model=get(h,'Value');

h=findobj('Tag','edit_NoiseThresh');
option.threshold_noise=get(h,'UserData');

h=findobj('Tag','popupmenu_OptiMethod');
opti_string=get(h,'String');
option.opti_method=opti_string{get(h,'Value')};

h=findobj('Tag','edit_DSUB');
option.D_star_ub=get(h,'UserData');
h=findobj('Tag','edit_DSLB');
option.D_star_lb=get(h,'UserData');
h=findobj('Tag','edit_DUB');
option.D_ub=get(h,'UserData');
h=findobj('Tag','edit_DLB');
option.D_lb=get(h,'UserData');
h=findobj('Tag','edit_fUB');
option.f_ub=get(h,'UserData');
h=findobj('Tag','edit_fLB');
option.f_lb=get(h,'UserData');

outdata=ivim(I,b_val,option);
set(hObject,'UserData',outdata);

d = dialog('Units','Normalized','Position',[0.45 0.45 0.25 0.15],'Name','Message');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Fontsize',10,...
    'Units','Normalized',...
    'HorizontalAlignment','left',...
    'Position',[0.35 0.6 0.35 0.2],...
    'String','Calculation Finish!');

btn = uicontrol('Parent',d,...
    'Units','Normalized',...
    'Position',[0.4 0.15 0.2 0.2],...
    'Fontsize',10,...    
    'String','Close',...
    'Callback','delete(gcf)');



% --- Executes during object creation, after setting all properties.
function radiobutton_stdModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_stdModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObject.Value=1;


% --- Executes during object creation, after setting all properties.
function radiobutton_modModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_modModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObject.Value=0;


% --- Executes on button press in checkbox_PartialB.
function checkbox_PartialB_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_PartialB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_PartialB
if(get(hObject,'Value'))
    bval = Partial_B;
    set(hObject,'UserData',bval);    
end


% --- Executes on selection change in popupmenu_Dmethod.
function popupmenu_Dmethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Dmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Dmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Dmethod


% --- Executes during object creation, after setting all properties.
function popupmenu_Dmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Dmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
indata=get(h,'UserData');

h=findobj('Tag','checkbox_quantizer');
result_quantizer=get(h,'Value');

h=findobj('Tag','checkbox_filter');
use_filter=get(h,'Value');


h=findobj('Tag','edit_fUB');
var_bound.f_ub=get(h,'UserData');
h=findobj('Tag','edit_fLB');
var_bound.f_lb=get(h,'UserData');

h=findobj('Tag','edit_DUB');
var_bound.D_ub=get(h,'UserData');
h=findobj('Tag','edit_DLB');
var_bound.D_lb=get(h,'UserData');

h=findobj('Tag','edit_DSUB');
var_bound.D_star_ub=get(h,'UserData');
h=findobj('Tag','edit_DSLB');
var_bound.D_star_lb=get(h,'UserData');

outdata=results_postproc(indata,result_quantizer,use_filter,var_bound);
set(hObject,'UserData',outdata);


h_plot=handles.axes_fmpa;
axes(h_plot);
cla;
imagesc(outdata.f);
h_plot.Visible='On';
h_plot=handles.text_f;
h_plot.Visible='On';


h_plot=handles.axes_Dmap;
axes(h_plot);
cla;
imagesc(outdata.D);
h_plot.Visible='On';
h_plot=handles.text_D;
h_plot.Visible='On';

h_plot=handles.axes_Dstar;
axes(h_plot);
cla;
imagesc(outdata.D_star);
h_plot.Visible='On';
h_plot=handles.text_Dstar;
h_plot.Visible='On';




% --- Executes on button press in checkbox_quantizer.
function checkbox_quantizer_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_quantizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_quantizer


% --- Executes on button press in checkbox_filter.
function checkbox_filter_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_filter


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes_OriPic);
cla reset



axes(handles.axes_fmpa);
cla reset
% h_plot=findobj('Tag','axes_fmpa');
% h_plot.Visible='off';

axes(handles.axes_Dmap);
cla reset
% h_plot=findobj('Tag','axes_Dstar');
% h_plot.Visible='off';

axes(handles.axes_Dstar);
cla reset
% h_plot=findobj('Tag','axes_Dmap');
% h_plot.Visible='off';

h=findobj('Tag','pushbutton_calculate');
set(h,'UserData',[]);
h=findobj('Tag','Load_ROI');
set(h,'UserData',[]);

h=findobj('Tag','File_Load');
set(h,'UserData',[]);




% --- Executes on button press in pushbutton_rota.
function pushbutton_rota_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rota (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','File_Load');
Image_info=get(h,'UserData');
I=Image_info.Image;
I= rot90(I);
Image_info.Image=I;
set(h,'UserData',Image_info);

h_plot=handles.axes_OriPic;
axes(h_plot);
cla;
imagesc(I(:,:,1));



h=findobj('Tag','pushbutton_plot');
outdata=get(h,'UserData');
get(hObject,'UserData');
outdata.f=rot90(outdata.f);
outdata.D=rot90(outdata.D);
outdata.D_star=rot90(outdata.D_star);
set(h,'UserData',outdata);

h_plot=handles.axes_fmpa;
axes(h_plot);
cla;
imagesc(outdata.f);

h_plot=handles.axes_Dmap;
axes(h_plot);
cla;
imagesc(outdata.D);

h_plot=handles.axes_Dstar;
axes(h_plot);
cla;
imagesc(outdata.D_star);

h=findobj('Tag','pushbutton_calculate');
indata=get(h,'UserData');
indata.f=rot90(indata.f);
indata.D=rot90(indata.D);
indata.D_star=rot90(indata.D_star);
set(h,'UserData',indata);


h=findobj('Tag','Load_ROI');
BW=get(h,'UserData');
BW=rot90(BW);
set(h,'UserData',BW);


% --------------------------------------------------------------------
function Export_Callback(hObject, eventdata, handles)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DICOM_Callback(hObject, eventdata, handles)
% hObject    handle to DICOM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --------------------------------------------------------------------
function NII_Callback(hObject, eventdata, handles)
% hObject    handle to NII (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Export_f_Callback(hObject, eventdata, handles)
% hObject    handle to Export_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
f_matrix=outdata.f;
clear outdata;


h=findobj('Tag','edit_fUB');
f_ub=get(h,'UserData');
h=findobj('Tag','edit_fLB');
f_lb=get(h,'UserData');

% f_matrix=(f_matrix-f_lb)*(2^16-1)/(f_ub-f_lb);
f_matrix=(f_matrix-f_lb)*10^4/(f_ub-f_lb);
[filename, pathname] = uiputfile('*.dcm','Export File');
dicomwrite(uint16(f_matrix), strcat(pathname,filename));


% --------------------------------------------------------------------
function Export_D_Callback(hObject, eventdata, handles)
% hObject    handle to Export_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
D_matrix=outdata.D;
clear outdata;

h=findobj('Tag','edit_DUB');
D_ub=get(h,'UserData');
h=findobj('Tag','edit_DLB');
D_lb=get(h,'UserData');
% D_matrix=(D_matrix-D_lb)*(2^16-1)/(D_ub-D_lb);
D_matrix=(D_matrix-D_lb)*10^4/(D_ub-D_lb);
[filename, pathname] = uiputfile('*.dcm','Export File');
dicomwrite(uint16(D_matrix), strcat(pathname,filename));



% --------------------------------------------------------------------
function Export_Dstar_Callback(hObject, eventdata, handles)
% hObject    handle to Export_Dstar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
D_star=outdata.D_star;
clear outdata;

h=findobj('Tag','edit_DSUB');
D_star_ub=get(h,'UserData');
h=findobj('Tag','edit_DSLB');
D_star_lb=get(h,'UserData');

% D_star=(D_star-D_star_lb)*(2^16-1)/(D_star_ub-D_star_lb);
D_star=(D_star-D_star_lb)*10^4/(D_star_ub-D_star_lb);
[filename, pathname] = uiputfile('*.dcm','Export File');
dicomwrite(uint16(D_star), strcat(pathname,filename));


% --------------------------------------------------------------------
function Export_f_nii_Callback(hObject, eventdata, handles)
% hObject    handle to Export_f_nii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
f_matrix=outdata.f;
clear outdata;


h=findobj('Tag','edit_fUB');
f_ub=get(h,'UserData');
h=findobj('Tag','edit_fLB');
f_lb=get(h,'UserData');

% f_matrix=(f_matrix-f_lb)*(2^16-1)/(f_ub-f_lb);
% f_matrix=(f_matrix-f_lb)*10^4/(f_ub-f_lb);
f_matrix=(f_matrix-f_lb)*1/(f_ub-f_lb);
nii = make_nii(f_matrix, 16);
[filename, pathname] = uiputfile('*.nii','Export File');
save_nii(nii, strcat(pathname,filename));






% --------------------------------------------------------------------
function Export_D_nii_Callback(hObject, eventdata, handles)
% hObject    handle to Export_D_nii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
D_matrix=outdata.D;
clear outdata;

h=findobj('Tag','edit_DUB');
D_ub=get(h,'UserData');
h=findobj('Tag','edit_DLB');
D_lb=get(h,'UserData');
% D_matrix=(D_matrix-D_lb)*(2^16-1)/(D_ub-D_lb);
% D_matrix=(D_matrix-D_lb)*10^4/(D_ub-D_lb);
D_matrix=(D_matrix-D_lb)*1/(D_ub-D_lb);
nii = make_nii(D_matrix, 16);
[filename, pathname] = uiputfile('*.nii','Export File');
save_nii(nii, strcat(pathname,filename));

% --------------------------------------------------------------------
function Export_Dstar_nii_Callback(hObject, eventdata, handles)
% hObject    handle to Export_Dstar_nii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
D_star=outdata.D_star;
clear outdata;

h=findobj('Tag','edit_DSUB');
D_star_ub=get(h,'UserData');
h=findobj('Tag','edit_DSLB');
D_star_lb=get(h,'UserData');

% D_star=(D_star-D_star_lb)*(2^16-1)/(D_star_ub-D_star_lb);
% D_star=(D_star-D_star_lb)*10^4/(D_star_ub-D_star_lb);
D_star=(D_star-D_star_lb)*1/(D_star_ub-D_star_lb);
nii = make_nii(D_star, 16);
[filename, pathname] = uiputfile('*.nii','Export File');
save_nii(nii, strcat(pathname,filename));


% --------------------------------------------------------------------
function f_ROI_Signal_Callback(hObject, eventdata, handles)
% hObject    handle to f_ROI_Signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
f_matrix=outdata.f;
clear outdata;

h=findobj('Tag','edit_fUB');
f_ub=get(h,'UserData');
h=findobj('Tag','edit_fLB');
f_lb=get(h,'UserData');

f_matrix1=uint16((f_matrix-f_lb)*(2^16-1)/(f_ub-f_lb));
h=figure;
BW = roipoly(f_matrix1);
ADChist3w(BW,f_matrix);



% --------------------------------------------------------------------
function D_ROI_Signal_Callback(hObject, eventdata, handles)
% hObject    handle to D_ROI_Signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
D_matrix=outdata.D;
clear outdata;

h=findobj('Tag','edit_DUB');
D_ub=get(h,'UserData');
h=findobj('Tag','edit_DLB');
D_lb=get(h,'UserData');
D_matrix1=uint16((D_matrix-D_lb)*(2^16-1)/(D_ub-D_lb));

h=figure;
BW = roipoly(D_matrix1);
ADChist3w(BW,D_matrix);




% --------------------------------------------------------------------
function DS_ROI_Signal_Callback(hObject, eventdata, handles)
% hObject    handle to DS_ROI_Signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','pushbutton_calculate');
outdata=get(h,'UserData');
D_star=outdata.D_star;
clear outdata;

h=findobj('Tag','edit_DSUB');
D_star_ub=get(h,'UserData');
h=findobj('Tag','edit_DSLB');
D_star_lb=get(h,'UserData');

D_star1=uint16((D_star-D_star_lb)*(2^16-1)/(D_star_ub-D_star_lb));
h=figure;
BW = roipoly(D_star1);
ADChist3w(BW,D_star);


% --------------------------------------------------------------------
function Image_Flip_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','File_Load');
Image_info=get(h,'UserData');
I=Image_info.Image;
I= fliplr(I);
Image_info.Image=I;
set(h,'UserData',Image_info);

h_plot=handles.axes_OriPic;
axes(h_plot);
cla;
imagesc(I(:,:,1));



h=findobj('Tag','pushbutton_plot');
outdata=get(h,'UserData');
get(hObject,'UserData');
outdata.f=fliplr(outdata.f);
outdata.D=fliplr(outdata.D);
outdata.D_star=fliplr(outdata.D_star);
set(h,'UserData',outdata);

h_plot=handles.axes_fmpa;
axes(h_plot);
cla;
imagesc(outdata.f);

h_plot=handles.axes_Dmap;
axes(h_plot);
cla;
imagesc(outdata.D);

h_plot=handles.axes_Dstar;
axes(h_plot);
cla;
imagesc(outdata.D_star);

h=findobj('Tag','pushbutton_calculate');
indata=get(h,'UserData');
indata.f=fliplr(indata.f);
indata.D=fliplr(indata.D);
indata.D_star=fliplr(indata.D_star);
set(h,'UserData',indata);


h=findobj('Tag','Load_ROI');
BW=get(h,'UserData');
BW=fliplr(BW);
set(h,'UserData',BW);


% --------------------------------------------------------------------
function Generate_TestPattern_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_TestPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Generate_TestPattern();
