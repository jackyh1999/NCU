function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for GUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.axes);
global index; global imds;
index = 1;
set(handles.btnPrevious,'Enable','off');
set(handles.btnPrevious,'Visible','off');
set(handles.btnNext,'Enable','off');
set(handles.btnNext,'Visible','off');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btnSelectImage.
function btnSelectImage_Callback(hObject, eventdata, handles)

set(handles.text,'string',' ');
set(handles.btnPrevious,'Enable','off');
set(handles.btnPrevious,'Visible','off');
set(handles.btnNext,'Enable','off');
set(handles.btnNext,'Visible','off');

file = "";
while file == ""
    % Get a .jpg file
    [file,path] = uigetfile('*.jpg');   
end
% Read image
fullfile = strcat(path,file);
set(handles.axes,'Name',fullfile);
image = imread(fullfile);

% Display image
axes = (handles.axes);
imshow( ClassifyAndDetect(image) );

% --- Executes on button press in btnBatch.
function btnBatch_Callback(hObject, eventdata, handles)
set(handles.text,'string',' ');
set(handles.btnPrevious,'Enable','off');
set(handles.btnPrevious,'Visible','off');
set(handles.btnNext,'Enable','off');
set(handles.btnNext,'Visible','off');
set(handles.axes,'Name','GUI');
G011();
set(handles.text,'string','Done');

% --- Executes on button press in btnSelectFolder.
function btnSelectFolder_Callback(hObject, eventdata, handles)
global index; global imds;

set(handles.text,'string',' ');

path = "";
while path == ""
    % Get a folder
    path = uigetdir();   
end

% Store image using image data store and augment it
imds = imageDatastore(path);
set(handles.axes,'Name',cell2mat(imds.Files(index,1)));
image = imread(cell2mat(imds.Files(index,1)));

% Display image
axes = (handles.axes);
imshow( ClassifyAndDetect(image) );

set(handles.btnNext,'Enable','on');
set(handles.btnNext,'Visible','on');

% --- Executes on button press in btnPrevious.
function btnPrevious_Callback(hObject, eventdata, handles)
global index; global imds;
index = index - 1;
set(handles.axes,'Name',cell2mat(imds.Files(index,1)));
image = imread(cell2mat(imds.Files(index,1)));

% Display image
axes = (handles.axes);
imshow( ClassifyAndDetect(image) );

if index == 1
    set(handles.btnPrevious,'Enable','off');
    set(handles.btnPrevious,'Visible','off');
end
if index == size(imds.Files,1)-1
    set(handles.btnNext,'Enable','on');
    set(handles.btnNext,'Visible','on');
end

% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
global index; global imds;
index = index + 1;
set(handles.axes,'Name',cell2mat(imds.Files(index,1)));
image = imread(cell2mat(imds.Files(index,1)));

% Display image
axes = (handles.axes);
imshow( ClassifyAndDetect(image) );

if index == size(imds.Files,1)
    set(handles.btnNext,'Enable','off');
    set(handles.btnNext,'Visible','off');
end
if index == 2
    set(handles.btnPrevious,'Enable','on');
    set(handles.btnPrevious,'Visible','on');
end

function out = mask(image,rec)
for x = 1:224
    for y = 1:224
        if x <= rec(1) || x >= rec(1)+rec(3) || y <= rec(2) || y >= rec(2)+rec(4)
            image(y,x,:) = 25;
        end
    end
end
out = image;

function outputimage = ClassifyAndDetect(image)

% Load trained net and classify image
trainedNet = load('Classifier.mat');
% Load trained detector
trainedDetector = load('GoodDetector.mat');

% Resize image to fit the detector and detect
outputimage = imresize(image,[224 224]);
bboxes = detect(trainedDetector.rcnn,outputimage);

object = (size(bboxes,2)*size(bboxes,1))/4;

outputimage1 = mask(outputimage,bboxes(1,:));
imwrite(outputimage1,'temp.jpg');
imds1 = imageDatastore('./temp.jpg');
YPred1 = classify(trainedNet.trainedNet,imds1);

if object == 2
outputimage2 = mask(outputimage,bboxes(2,:));
imwrite(outputimage2,'temp.jpg');
imds2 = imageDatastore('./temp.jpg');
YPred2 = classify(trainedNet.trainedNet,imds2);
end

% Insert annotation into image
outputimage = insertObjectAnnotation(outputimage,'rectangle',bboxes(1,:), sprintf('%s',YPred1),'LineWidth',4);
if object == 2
outputimage = insertObjectAnnotation(outputimage,'rectangle',bboxes(2,:), sprintf('%s',YPred2),'LineWidth',4);
end
