% Initialize variable
minX = {}; maxX = {}; minY = {}; maxY = {}; X = {}; Y = {}; Rec = {}; Path = {};
imdsSingle = imageDatastore('./Single');   
imdsDouble = imageDatastore('./Double');
fdsSingle = fileDatastore("./SingleLabel",'ReadFcn',@parseLabel);
fdsDouble = fileDatastore("./DoubleLabel",'ReadFcn',@parseLabel);

% Sequential read
index = 1;
while hasdata(imdsSingle) && hasdata(fdsSingle)    
    % Read image from image datastore
    % image = imread(cell2mat(imdsSingle.Files(index,1)));
    % Resize image to fit imageinputlayer
    % image = imresize(image,[224 224]);
    % Put resize image into another folder
    newimagefile = strcat(strcat('./Test2resize/img_0',num2str(index)),'.jpg');  
    %imwrite(image,newimagefile);
    
    % Read coordinate from file datastore
    label = read(fdsSingle);
    minX{end+1} = min([cell2mat(label(1)) cell2mat(label(3)) cell2mat(label(5)) cell2mat(label(7))])*(224/1440);
    maxX{end+1} = max([cell2mat(label(1)) cell2mat(label(3)) cell2mat(label(5)) cell2mat(label(7))])*(224/1440);
    minY{end+1} = min([cell2mat(label(2)) cell2mat(label(4)) cell2mat(label(6)) cell2mat(label(8))])*(224/1080);
    maxY{end+1} = max([cell2mat(label(2)) cell2mat(label(4)) cell2mat(label(6)) cell2mat(label(8))])*(224/1080);
    X{end+1} = cell2mat(maxX(end)) - cell2mat(minX(end));
    Y{end+1} = cell2mat(maxY(end)) - cell2mat(minY(end));
    Rec{end+1} = [cell2mat(minX(end)) cell2mat(minY(end)) cell2mat(X(end)) cell2mat(Y(end))];
    Path{end+1} = newimagefile;   
    % Show part of resize image with annotation
    % if mod(index,1000) == 1
    %     I = insertObjectAnnotation(image,'Rectangle',cell2mat(Rec(1,index)),'test','LineWidth',8);
    %     figure
    %     imshow(I)
    % end  
    index = index + 1;
end
index = 1;
while hasdata(imdsDouble) && hasdata(fdsDouble)
    % Read image from image datastore
    % image = imread(cell2mat(imdsDouble.Files(index,1)));
    % Resize image to fit imageinputlayer
    % image = imresize(image,[224 224]);
    % Put resize image into another folder
    newimagefile = strcat(strcat('./Test2resize/img2_0',num2str(index)),'.jpg');   
    % imwrite(image,newimagefile);
    
    % Read coordinate from file datastore
    label = read(fdsDouble);
    minX{end+1} = min([cell2mat(label(1)) cell2mat(label(3)) cell2mat(label(5)) cell2mat(label(7))])*(224/1440);
    maxX{end+1} = max([cell2mat(label(1)) cell2mat(label(3)) cell2mat(label(5)) cell2mat(label(7))])*(224/1440);
    minY{end+1} = min([cell2mat(label(2)) cell2mat(label(4)) cell2mat(label(6)) cell2mat(label(8))])*(224/1080);
    maxY{end+1} = max([cell2mat(label(2)) cell2mat(label(4)) cell2mat(label(6)) cell2mat(label(8))])*(224/1080);
    X{end+1} = cell2mat(maxX(end)) - cell2mat(minX(end));
    Y{end+1} = cell2mat(maxY(end)) - cell2mat(minY(end));
    Rec{end+1} = [cell2mat(minX(end)) cell2mat(minY(end)) cell2mat(X(end)) cell2mat(Y(end))];
    Path{end+1} = newimagefile;
    
    minX{end+1} = min([cell2mat(label(10)) cell2mat(label(12)) cell2mat(label(14)) cell2mat(label(16))])*(224/1440);
    maxX{end+1} = max([cell2mat(label(10)) cell2mat(label(12)) cell2mat(label(14)) cell2mat(label(16))])*(224/1440);
    minY{end+1} = min([cell2mat(label(11)) cell2mat(label(13)) cell2mat(label(15)) cell2mat(label(17))])*(224/1080);
    maxY{end+1} = max([cell2mat(label(11)) cell2mat(label(13)) cell2mat(label(15)) cell2mat(label(17))])*(224/1080);
    X{end+1} = cell2mat(maxX(end)) - cell2mat(minX(end));
    Y{end+1} = cell2mat(maxY(end)) - cell2mat(minY(end));
    Rec{end+1} = [cell2mat(minX(end)) cell2mat(minY(end)) cell2mat(X(end)) cell2mat(Y(end))];
    Path{end+1} = newimagefile;
    
    % Show part of resize image with annotation
    if mod(index,1000) == 1
        I = insertObjectAnnotation(image,'Rectangle',cell2mat(Rec(1,index)),'test','LineWidth',8);
        figure
        imshow(I)
    end
    
    index = index + 1;
end

% Transpose rectangle to fit the format of training input argument
Rec = transpose(Rec);
Path = transpose(Path);
% Create a table for training
trainTable = table(Path,Rec);

% Use resnet18
net = resnet18
% Transform net to a layer graph, so we can replace layers in the network
lgraph = layerGraph(net);
% Replace fully connected layer 
newFCLayer = fullyConnectedLayer(2,'Name','new_fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'fc1000',newFCLayer);
% Replace classification layer
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'ClassificationLayer_predictions',newClassLayer);

% Set training options
options = trainingOptions('sgdm', ...
        'MiniBatchSize', 64, ...
        'InitialLearnRate', 1e-3, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.1, ...
        'LearnRateDropPeriod', 100, ...
        'MaxEpochs', 4, ...
        'Verbose', true);

% Train an R-CNN object detector. This will take several minutes.    
rcnn = trainRCNNObjectDetector(trainTable, lgraph, options,'NegativeOverlapRange', [0 0.5], 'PositiveOverlapRange',[0.5 1]);

function output = parseLabel(fileName)
    [x11,y11,x12,y12,x13,y13,x14,y14,label1,x21,y21,x22,y22,x23,y23,x24,y24,label2] = textread(fileName,"%d%d%d%d%d%d%d%d%s%d%d%d%d%d%d%d%d%s",'delimiter',',\n');
    output = [x11 y11 x12 y12 x13 y13 x14 y14 label1 x21 y21 x22 y22 x23 y23 x24 y24 label2] ;
end