function varargout = Calculator(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @Calculator_OutputFcn, ...
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

% --- Executes just before Calculator is made visible.
function Calculator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% Choose default command line output for Calculator
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Calculator wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global clear; global num1; global num2; global op; global isOP;
clear = 0; num1 = 0; num2 = 0; op = 0; isOP = 0;

% --- Outputs from this function are returned to the command line.
function varargout = Calculator_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btn_c.
function btn_c_Callback(hObject, eventdata, handles)
global num1; global num2; global op; global isOP;
% Create new string
str = sprintf('0');
% Update the text field
set (handles.number,'String',str);
set (handles.state,'String',' ');
num1 =0; num2 = 0; op = 0; isOP = 0;

% --- Executes on button press in btn_1.
function btn_1_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','1');
elseif clear == 1   
    clear = 0;
    set(handles.number,'String','1');
else 
    set(handles.number,'String',strcat(str,'1'));
end

% --- Executes on button press in btn_2.
function btn_2_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','2');
elseif clear == 1     
    clear = 0;
    set(handles.number,'String','2');
else 
    set(handles.number,'String',strcat(str,'2'));
end

% --- Executes on button press in btn_3.
function btn_3_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','3');
elseif clear == 1    
    clear = 0;
    set(handles.number,'String','3');
else 
    set(handles.number,'String',strcat(str,'3'));
end

% --- Executes on button press in btn_4.
function btn_4_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','4');
elseif clear == 1   
    clear = 0;
    set(handles.number,'String','4');
else 
    set(handles.number,'String',strcat(str,'4'));
end

% --- Executes on button press in btn_5.
function btn_5_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','5');
elseif clear == 1   
    clear = 0;
    set(handles.number,'String','5');
else 
    set(handles.number,'String',strcat(str,'5'));
end

% --- Executes on button press in btn_6.
function btn_6_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','6');
elseif clear == 1   
    clear = 0;
    set(handles.number,'String','6');
else 
    set(handles.number,'String',strcat(str,'6'));
end

% --- Executes on button press in btn_7.
function btn_7_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','7');
elseif clear == 1   
    clear = 0;
    set(handles.number,'String','7');
else 
    set(handles.number,'String',strcat(str,'7'));
end

% --- Executes on button press in btn_8.
function btn_8_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','8');
elseif clear == 1   
    clear = 0;
    set(handles.number,'String','8');
else 
    set(handles.number,'String',strcat(str,'8'));
end

% --- Executes on button press in btn_9.
function btn_9_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','9');
elseif clear == 1   
    clear = 0;
    set(handles.number,'String','9');
else 
    set(handles.number,'String',strcat(str,'9'));
end

% --- Executes on button press in btn_0.
function btn_0_Callback(hObject, eventdata, handles)
global clear;
str = get(handles.number,'String');
if str == "0"
    set(handles.number,'String','0');
elseif clear == 1    
    clear = 0;
    set(handles.number,'String','0');
else 
    set(handles.number,'String',strcat(str,'0'));
end

% --- Executes on button press in btn_equal.
function btn_equal_Callback(hObject, eventdata, handles)
global clear; global num1; global num2; global op; global isOP;
if isOP == 1 || isOP == 2
    clear = 1; isOP = 2;
    if get(handles.state,'String') ~= "="
        num2 = str2double(get(handles.number,'String'));
        set(handles.state,'String','=');
    end       
    num1=calculate(num1,num2,op);
    set(handles.number,'String',num2str(num1));    
end

% --- Executes on button press in btn_add.
function btn_add_Callback(hObject, eventdata, handles)
global clear; global num1; global num2; global op; global isOP;
if isOP == 1 
    num2 = str2double(get(handles.number,'String'));    
    set(handles.number,'String',num2str(calculate(num1,num2,op)));
end
num1 = str2double(get(handles.number,'String'));
op = 1; isOP = 1; clear = 1;
set(handles.state,'String','+');

% --- Executes on button press in btn_sub.
function btn_sub_Callback(hObject, eventdata, handles)
global clear; global num1; global num2; global op; global isOP;
if isOP == 1 
    num2 = str2double(get(handles.number,'String'));    
    set(handles.number,'String',num2str(calculate(num1,num2,op))); 
end
num1 = str2double(get(handles.number,'String'));
op = 2; isOP = 1; clear = 1;
set(handles.state,'String','-');

% --- Executes on button press in btn_mul.
function btn_mul_Callback(hObject, eventdata, handles)
global clear; global num1; global num2; global op; global isOP;
if isOP == 1 
    num2 = str2double(get(handles.number,'String'));          
    set(handles.number,'String',num2str(calculate(num1,num2,op))); 
end
num1 = str2double(get(handles.number,'String'));
op = 3; isOP = 1; clear = 1;
set(handles.state,'String','*');

% --- Executes on button press in btn_div.
function btn_div_Callback(hObject, eventdata, handles)
global clear; global num1; global num2; global op; global isOP;
if isOP == 1 
    num2 = str2double(get(handles.number,'String'));    
    set(handles.number,'String',num2str(calculate(num1,num2,op))); 
end
num1 = str2double(get(handles.number,'String'));
op = 4; isOP = 1; clear = 1;
set(handles.state,'String','/');

% --- Executes on button press in btn_point.
function btn_point_Callback(hObject, eventdata, handles)
global clear;
if clear == 1   
    clear = 0;
    set(handles.number,'String','0.');
else
    set(handles.number,'String',strcat(get(handles.number,'String'),'.'));
end

function result = calculate(num1,num2,op)
switch(op)
    case 1
        result=num1+num2;
    case 2
        result=num1-num2;
    case 3
        result=num1*num2;
    case 4
        result=num1/num2;
end       