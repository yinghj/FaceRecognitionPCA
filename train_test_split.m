% Load faces
IN_FOLDER = 'orl_faces_att';
SAMPLE_CNT = 40;
FACE_CNT = 10;
h = 112; w = 92;
K_knn = 1;
var_to_keep = 0.75;

faces = load_faces(IN_FOLDER, SAMPLE_CNT, FACE_CNT, h*w);
y = zeros(SAMPLE_CNT*FACE_CNT, 1);
for i = 1:SAMPLE_CNT*FACE_CNT
    y(i) = idivide(int32(i-1), int32(FACE_CNT))+1;
end
    
[pixels, numFaces] = size(faces);
meanFace = mean(faces, 2);

% get a random index
randomIdx = uint32(rand()*numFaces);
% split data
% into training set
Xtrain = faces(:, [1:(randomIdx-1), (randomIdx+1):numFaces]); 
ytrain = y([1:(randomIdx-1), (randomIdx+1):numFaces]);

% into test set
Xtest = faces(:,randomIdx);
ytest = y(randomIdx);

figure; imshow(imresize(reshape(Xtest, h, w),3)); title('Face to be classified');
pause; 

% compute a model
eigFaces = eigenfaces(Xtrain, var_to_keep);
% get a prediction from the model
predicted = eigenfaces_predict(Xtrain, eigFaces, meanFace, ...
    Xtest, ytrain, K_knn);

% display prediction result
face_img_idx = (predicted-1)*FACE_CNT+1;
figure; imshow(imresize(reshape(faces(:, face_img_idx), h, w),3)); 
title('Recognized as face');
pause;
fprintf(1,'predicted=%d,actual=%d\n', predicted, ytest)