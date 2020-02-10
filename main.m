function varargout = main(varargin)
tic;

% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%cre
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 16-Jan-2020 19:00:23

% Begin initialization code - DO NOT EDIT
tic;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
               toc;
               
               tic;
if nargin && ischar(varargin{1})
  
    gui_State.gui_Callback = str2func(varargin{1});
end
toc;

tic;
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
toc;
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
tic;

% jFrame=get(handles.figure1,'javaframe');  
% jicon=javax.swing.ImageIcon('received_794070037686646.png');
% jFrame.setFigureIcon(jicon);
% handles.output = hObject;
% guidata(hObject, handles);
% % This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
bg = imread('back2.jpg'); imagesc(bg);

set(ah,'handlevisibility','off','visible','off')

% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');


% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

toc;
% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
tic;
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

toc;
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
tic;
x = 0;
waitb = 0;
wb = waitbar(x,'Start Calling Camera');
waitbar(x + 0.2, wb, 'Start Calling Camera...');    
parpool(4);
waitbar(x + 0.4, wb, 'Deleting Start button...');

set(handles.pushbutton1,'Visible','off');
waitbar(x + 0.6, wb, 'Enabled Close button...');

set(handles.pushbutton4,'Visible','on');
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
waitbar(x + 0.8, wb, 'Wait until camera is open...');
camera = webcam();
nnet = alexnet;
waitbar(x + 1, wb, 'Done');
delete(wb);

toc;

tic;
while true
    picture = camera.snapshot;
    picture = imresize(picture,[227,227]);
    label = classify(nnet, picture);
    
    image(picture);
    tic;
    if label == 'banana'
        set(handles.edit1, 'ForegroundColor', 'green', 'string', '+ YES');
        toc;
        
        bel = res_train_classes(picture);
        
        tic;
        if bel == 'A' || bel == 'B'
            set(handles.edit2, 'ForegroundColor', 'green', 'string', '+ YES');
            set(handles.edit3, 'ForegroundColor', 'green', 'string', bel);
            toc;
                   tic;
        diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
      diff_im = medfilt2(diff_im, [3 3]);
      diff_im = imbinarize(diff_im,0.18);
      diff_im = bwareaopen(diff_im,300);
      bw = bwlabel(diff_im, 8);
      stats = regionprops(bw, 'BoundingBox', 'Centroid');
      toc;
      
      tic;
        imshow(picture)
        toc;
        
        tic;
      hold on
      for object = 1:length(stats)
          bb = stats(object).BoundingBox;
          bc = stats(object).Centroid;
          rectangle('Position',bb,'EdgeColor','g','LineWidth',2)
          plot(bc(1),bc(2), '-m+')
          a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
          set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
      end
      toc;
      
      hold off
       drawnow limitrate;
       tic;
    if ~isempty(stats)
            set(handles.edit4, 'ForegroundColor', 'green', 'string', '+ YES');
        else
            set(handles.edit4, 'ForegroundColor', 'red', 'string', '- NO');
    end
    toc;
    
    tic;
          a = blacked_background(picture);
        imshow(a);
        drawnow limitrate;
        toc;
        
        tic;
        
%         grayImage = picture;
% [rows, columns, numberOfColorChannels] = size(grayImage)
% if numberOfColorChannels > 1
%   grayImage = rgb2gray(grayImage);
% end
% toc;
% 
% binaryImage = grayImage == 0;
% binaryImage = imclearborder(binaryImage);
% [labeledImage, numBlobs] = bwlabel(~im2bw(binaryImage,0.7));
% coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
% total_bk_spots=numBlobs-1
% props = regionprops(labeledImage, 'BoundingBox', 'Centroid');
% 
% imshow(a);
% hold on;
% for k = 1 : numBlobs
%    bb = props(k).BoundingBox;
%    bc = props(k).Centroid;
%    rectangle('Position',bb,'EdgeColor','c','LineWidth',2);
% end
% drawnow limitrate;
% hold off
tic;

grayImage = a;
[rows, columns, numberOfColorChannels] = size(grayImage);
toc;

tic;
if numberOfColorChannels > 1
  grayImage = rgb2gray(grayImage);
end

toc;

tic;
hp = impixelinfo();
binaryImage = grayImage == 0;
binaryImage = imclearborder(binaryImage);
[labeledImage, numBlobs] = bwlabel(~binaryImage);
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
props = regionprops(labeledImage, 'BoundingBox', 'Centroid');
toc;

tic;
imshow(picture);
hold on;
toc;

tic;
for k = 1 : numBlobs
   bb = props(k).BoundingBox;
   bc = props(k).Centroid;
   rectangle('Position',bb,'EdgeColor','c','LineWidth',2);
end

drawnow limitrate;
toc;

tic;
    if ~isempty(numBlobs) && numBlobs > 1
            set(handles.edit5, 'ForegroundColor', 'r', 'string',numBlobs);
        else
            set(handles.edit5, 'ForegroundColor', 'green', 'string', '- NONE');
    end
    toc;
    
    tic;
  if isempty(numBlobs) && ~isempty(stats) && numBlobs > 1
      title('Accepted');
          h = waitbar(0,'ACCEPTED');
    steps = 1000;
    for step = 800:steps
        waitbar(step / steps)
    end
    close(h)
  else
      title('Reject');
             h = waitbar(0,'REJECT');
    steps = 1000;
    for step = 800:steps
        waitbar(step / steps)
    end
    close(h)
  end
  toc;
        else
               toc; 
            set(handles.edit2, 'ForegroundColor', 'r', 'string', '- NONE');
            set(handles.edit3, 'ForegroundColor', 'r', 'string', '--');
            set(handles.edit4, 'ForegroundColor', 'r', 'string', '--');
            set(handles.edit5, 'ForegroundColor', 'r', 'string', '--');
            title('REJECT');
        
        toc;
    end
        
    else
    tic;
        drawnow limitrate;
        toc;
        set(handles.edit1, 'ForegroundColor', 'r', 'string', '- NONE');
        set(handles.edit2, 'ForegroundColor', 'r', 'string', '--');
        set(handles.edit3, 'ForegroundColor', 'r', 'string', '--');
        set(handles.edit4, 'ForegroundColor', 'r', 'string', '--');
        set(handles.edit5, 'ForegroundColor', 'r', 'string', '--');
        

      


end    
end


toc;
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all; clear all; clc; delete(gcp('nocreate'));


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    toc;
end



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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
