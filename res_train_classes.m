function [labels] = res_train_classes(img)
%%
outputFolder = fullfile('Classes');
rootFolder = fullfile(outputFolder, 'verify');

%%
categories = {'A', 'B', 'other'};
imds = imageDatastore(fullfile(rootFolder,categories), 'LabelSource', 'foldernames');

%%
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2});

%%
imds = splitEachLabel(imds, minSetCount,'randomize');
countEachLabel(imds);

%%
A = find(imds.Labels == 'A', 1);
B = find(imds.Labels == 'B', 1);
other = find(imds.Labels == 'other', 1);
%%
net = resnet50();
net.Layers(1);

%%
net.Layers(end);
numel(net.Layers(end).ClassNames);

%%
[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');
imageSize = net.Layers(1).InputSize;

%%
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet,'ColorPreprocessing', 'gray2rgb');

%%
w1 = net.Layers(2).Weights;
w1 = mat2gray(w1);

%%
featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');

%%
trainingLables = trainingSet.Labels;
classifier = fitcecoc(trainingFeatures, trainingLables, 'Learner', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

%%
testFeatures = activations(net, augmentedTestSet, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');
predictLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

%%
testLables = testSet.Labels;
confMat = confusionmat(testLables, predictLabels);

%%
confMat = bsxfun(@rdivide, confMat, sum(confMat,2));
mean(diag(confMat));

newImage = img;
%%
ds = augmentedImageDatastore(imageSize, newImage, 'ColorPreprocessing', 'gray2rgb');
imageFeatures = activations(net, ds, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');

%%
labels = predict(classifier, imageFeatures, 'ObservationsIn', 'columns');

end

