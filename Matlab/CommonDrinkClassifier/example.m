function G011(imgPath)

objectNumber = [];
Labels = strings([,2]);

imds = imageDatastore(uigetdir);

trainedNet = load('Classifier.mat');
trainedDetector = load('GoodDetector.mat');

index = 1;
while index <= size(imds.Files,1)
    image = imread(cell2mat(imds.Files(index,1)));
    image = imresize(image,[224 224]);
    bboxes = detect(trainedDetector.rcnn,image);
    object = (size(bboxes,2)*size(bboxes,1))/4;
    
    if object == 1
        objectNumber(end+1) = object;
        
        image = mask(image,bboxes(1,:));
        imwrite(image,'temp.jpg');
        imdsTemp = imageDatastore('./temp.jpg');
        YPred = classify(trainedNet.trainedNet,imdsTemp);
        
        Labels(index,1) = cellstr(YPred);
        Labels(index,2) = " ";

    elseif object == 2
        objectNumber(end+1) = object;
        
        image1 = mask(image,bboxes(1,:));  
        imwrite(image1,'temp1.jpg');
        imdsTemp = imageDatastore('./temp1.jpg');
        YPred1 = classify(trainedNet.trainedNet,imdsTemp);
        
        image2 = mask(image,bboxes(2,:));
        imwrite(image,'temp2.jpg');
        imdsTemp = imageDatastore('./temp2.jpg');
        YPred2 = classify(trainedNet.trainedNet,imdsTemp);
        
        Labels(index,1) = cellstr(YPred1);
        Labels(index,2) = cellstr(YPred2);
    end  
    index = index + 1;
end

fileID = fopen('G011.txt','w');
for i = 1:index-1
    fprintf(fileID, '%d,%d,%s,%s\n',i,objectNumber(i),Labels(i,1),Labels(i,2));
end
fclose(fileID);

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