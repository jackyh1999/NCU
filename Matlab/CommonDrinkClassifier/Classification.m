% Initialize variable
imds = imageDatastore({'./Single','./Double','./Double_2'},'labelsource', 'foldernames');
fds = fileDatastore({'./SingleLabel','./DoubleLabel','./DoubleLabel'},'ReadFcn',@parseLabel);
minX = {}; maxX = {}; minY = {}; maxY = {}; X = {}; Y = {}; Rec = {};

% Sequential read
index = 1;
while hasdata(imds) && hasdata(fds)
    image = imread(cell2mat(imds.Files(index,1)));
    label = read(fds);
    
    % Get object's position and its label
    if index < 5350
        minX{end+1} = min([cell2mat(label(1)) cell2mat(label(3)) cell2mat(label(5)) cell2mat(label(7))])*(224/1440);
        maxX{end+1} = max([cell2mat(label(1)) cell2mat(label(3)) cell2mat(label(5)) cell2mat(label(7))])*(224/1440);
        minY{end+1} = min([cell2mat(label(2)) cell2mat(label(4)) cell2mat(label(6)) cell2mat(label(8))])*(224/1080);
        maxY{end+1} = max([cell2mat(label(2)) cell2mat(label(4)) cell2mat(label(6)) cell2mat(label(8))])*(224/1080);
        imds.Labels(index,1) = label(9);
    else
        minX{end+1} = min([cell2mat(label(10)) cell2mat(label(12)) cell2mat(label(14)) cell2mat(label(16))])*(224/1440);
        maxX{end+1} = max([cell2mat(label(10)) cell2mat(label(12)) cell2mat(label(14)) cell2mat(label(16))])*(224/1440);
        minY{end+1} = min([cell2mat(label(11)) cell2mat(label(13)) cell2mat(label(15)) cell2mat(label(17))])*(224/1080);
        maxY{end+1} = max([cell2mat(label(11)) cell2mat(label(13)) cell2mat(label(15)) cell2mat(label(17))])*(224/1080);
        imds.Labels(index,1) = label(18);
    end
    % transfer to a rectangle that includes X, Y, Width, Height 
    X{end+1} = cell2mat(maxX(end)) - cell2mat(minX(end));
    Y{end+1} = cell2mat(maxY(end)) - cell2mat(minY(end));
    Rec{end+1} = [cell2mat(minX(end)) cell2mat(minY(end)) cell2mat(X(end)) cell2mat(Y(end))];
    % Resize image and give it a mask
    image = imresize(image,[224 224]);
    image = mask(image,Rec{end});
    % Show parts of image
    if mod(index,1000) == 1
        imds.Labels(index,1)
        figure;
        imshow(image);
    end
    % Cover the original image
    % imwrite(image,cell2mat(imds.Files(index,1))); 
    index = index + 1;
end

% Use resnet18
net = resnet18;

% Decide how many files to be trained and split the labels 
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7,'randomized');

% Count how many classses are in the image data store
numClasses = numel(categories(imdsTrain.Labels))

% Transform net to a layer graph, so we can replace layers in the network
lgraph = layerGraph(net);
% Replace fully connected layer 
newFCLayer = fullyConnectedLayer(numClasses,'Name','new_fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'fc1000',newFCLayer);
% Replace classification layer
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'ClassificationLayer_predictions',newClassLayer);

% Set training options
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',8, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',100, ...
    'Verbose',false, ...
    'Plots','training-progress');

% Train Network Using Training Data
% training data, layers, options
trainedNet = trainNetwork(imdsTrain,lgraph,options);

% Classify Validation Images and Compute Accuracy   
% Predict the labels of the validation data using the trained network, 
% and calculate the final validation accuracy.
YPred = classify(trainedNet,imdsValidation)
accuracy = mean(YPred == imdsValidation.Labels)

function output = parseLabel(fileName)
    [x11,y11,x12,y12,x13,y13,x14,y14,label1,x21,y21,x22,y22,x23,y23,x24,y24,label2] = textread(fileName,"%d%d%d%d%d%d%d%d%s%d%d%d%d%d%d%d%d%s",'delimiter',',\n');
    output = [x11 y11 x12 y12 x13 y13 x14 y14 label1 x21 y21 x22 y22 x23 y23 x24 y24 label2] ;
end

function out = mask(image,rec)
for x = 1:224
    for y = 1:224
        if x < rec(1) || x > rec(1)+rec(3) || y < rec(2) || y > rec(2)+rec(4)
            image(y,x,:) = 0;
        end
    end
end
out = image;
end
