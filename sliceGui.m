function varargout = sliceGui(varargin)
% SLICEGUI MATLAB code for sliceGui.fig
%      SLICEGUI, by itself, creates a new SLICEGUI or raises the existing
%      singleton*.
%
%      H = SLICEGUI returns the handle to a new SLICEGUI or the handle to
%      the existing singleton*.
%
%      SLICEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLICEGUI.M with the given input arguments.
%
%      SLICEGUI('Property','Value',...) creates a new SLICEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sliceGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sliceGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sliceGui

% Last Modified by GUIDE v2.5 20-Aug-2015 11:44:23

% Begin initialization code - DO NOT EDIT

global fileGroups
fileGroups = getFileGroups('data');

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sliceGui_OpeningFcn, ...
                   'gui_OutputFcn',  @sliceGui_OutputFcn, ...
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

% --- Executes just before sliceGui is made visible.
function sliceGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sliceGui (see VARARGIN)

% Choose default command line output for sliceGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using sliceGui.
if strcmp(get(hObject,'Visible'),'off')
    imsc(imread('initialGuiMessage.png'))
end

% UIWAIT makes sliceGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sliceGui_OutputFcn(hObject, eventdata, handles)
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
axes(handles.axes1);
cla;

global fileGroups

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
case 1
    disp('Detected filegroup 1')
    fileGroup = fileGroups{1};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 2
    disp('Detected filegroup 2')
    fileGroup = fileGroups{2};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 3
    disp('Detected filegroup 3')
    fileGroup = fileGroups{3};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 4
    disp('Detected filegroup 4')
    fileGroup = fileGroups{4};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 5
    disp('Detected filegroup 5')
    fileGroup = fileGroups{5};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 6
    disp('Detected filegroup 6')
    fileGroup = fileGroups{6};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 7
    disp('Detected filegroup 7')
    fileGroup = fileGroups{7};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 8
    disp('Detected filegroup 8')
    fileGroup = fileGroups{8};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 9
    disp('Detected filegroup 9')
    fileGroup = fileGroups{9};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 10
    disp('Detected filegroup 10')
    fileGroup = fileGroups{10};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
case 11
    disp('Detected filegroup 11')
    fileGroup = fileGroups{11};
    fileName = fileGroup{1};
    imgSlice = normImage(loadGed(fileName(1:end-5)), 1);
    imsc(imgSlice)
end


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
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%               DATASET SELECTION POPUP MENU                              %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
contents = get(hObject,'String');
fprintf('Dataset selected: %s\n', contents{get(hObject,'Value')})


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Dataset 1', 'Dataset 2', 'Dataset 3', 'Dataset 4', 'Dataset 5',...
'Dataset 6', 'Dataset 7', 'Dataset 8', 'Dataset 9', 'Dataset 10', 'Dataset 11'});



function datafilesPath_Callback(hObject, eventdata, handles)
% hObject    handle to datafilesPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datafilesPath as text
%        str2double(get(hObject,'String')) returns contents of datafilesPath as a double
datafilesPath = get(hObject,'String');
fprintf('Datafiles path is: %s\n', datafilesPath)
if not(exist(datafilesPath, 'dir'))
    warning('Folder %s doesn''t exist')
else
    fileGroups = getFileGroups(datafilesPath);
    for ii = 1:length(fileGroups)
        disp(fileGroups{ii})
    end
end




% --- Executes during object creation, after setting all properties.
function datafilesPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datafilesPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
