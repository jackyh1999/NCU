function G011(imgPath)

objectNumber = [];
Labels = strings([,2]);
fileName = strings(0);

imds = imageDatastore(uigetdir);

trainedNet = load('Classifier.mat');
trainedDetector = load('GoodDetector.mat');

index = 1;
while index <= size(imds.Files,1)
    fileName(end+1) = cell2mat(imds.Files(index,1));
    image = imread(cell2mat(imds.Files(index,1)));
    image = imresize(image,[224 224]);
    bboxes = detect(trainedDetector.rcnn,image);
    object = (size(bboxes,2)*size(bboxes,1))/4;
    
    if object == 1
        objectNumber(end+1) = object;
        for x = 1:224
            for y = 1:224
                if x < bboxes(1,1) || x >  bboxes(1,1)+ bboxes(1,3) || y <  bboxes(1,2) || y >  bboxes(1,2)+ bboxes(1,4)
                    image(y,x,:) = 0;
                end
            end
        end
        imwrite(image,'temp.jpg');
        imdsTemp = imageDatastore('./temp.jpg');
        YPred = classify(trainedNet.trainedNet,imdsTemp);
        
        Labels(index,1) = cellstr(YPred);
        Labels(index,2) = " ";

    elseif object == 2
        objectNumber(end+1) = object;
        image1 = image; 
        for x = 1:224
            for y = 1:224
                if x < bboxes(1,1) || x >  bboxes(1,1)+ bboxes(1,3) || y <  bboxes(1,2) || y >  bboxes(1,2)+ bboxes(1,4)
                    image1(y,x,:) = 0;
                end
            end
        end
         
        imwrite(image1,'temp1.jpg');
        imdsTemp = imageDatastore('./temp1.jpg');
        YPred1 = classify(trainedNet.trainedNet,imdsTemp);
        
        image2 = image; 
        for x = 1:224
            for y = 1:224
                if x < bboxes(2,1) || x >  bboxes(2,1)+ bboxes(2,3) || y <  bboxes(2,2) || y >  bboxes(2,2)+ bboxes(2,4)
                    image2(y,x,:) = 0;
                end
            end
        end
        imwrite(image,'temp2.jpg');
        imdsTemp = imageDatastore('./temp2.jpg');
        YPred2 = classify(trainedNet.trainedNet,imdsTemp);
        
        Labels(index,1) = cellstr(YPred1);
        Labels(index,2) = cellstr(YPred2);
    else 
        objectNumber(end+1) = 0;
        Labels(index,1) = "null";
        Labels(index,2) = "null";
    end  
    index = index + 1;
end

fileID = fopen('G011.txt','w');
for i = 1:index-1 
    fprintf(fileID, '%s,%d,%s,%s\n',fileName(i),objectNumber(i),Labels(i,1),Labels(i,2));
end
fclose(fileID);

end
