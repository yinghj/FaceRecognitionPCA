% Load faces
IN_FOLDER = 'orl_faces_att';
SAMPLE_CNT = 40;
FACE_CNT = 10;
h = 112; w = 92;
K_knn = 1;
vars_to_keep = 0.5:0.1:1;

faces = load_faces(IN_FOLDER, SAMPLE_CNT, FACE_CNT, h*w);
y = zeros(SAMPLE_CNT*FACE_CNT, 1);
for i = 1:SAMPLE_CNT*FACE_CNT
    y(i) = idivide(int32(i-1), int32(FACE_CNT))+1;
end

[pixels, numFaces] = size(faces);
meanFace = mean(faces, 2);

tpr_var = zeros(size(vars_to_keep, 2), 1);

for i = 1:size(vars_to_keep, 2)
    % Learn Eigenfaces
    eigenfaces_train = @(Xtrain) eigenfaces(Xtrain, vars_to_keep(i));
    eigenfaces_test = @(Xtrain, eigFaces, Xtest, ytrain) ...
        eigenfaces_predict(Xtrain, eigFaces, meanFace, Xtest, ytrain, K_knn);

    fprintf(1,'propEnergy=%.1f\n', vars_to_keep(i));
    % a 10-fold cross validation (per fold=0, debug=1)
    cv1 = KFoldCV(faces,y,10,eigenfaces_train, eigenfaces_test, 0, 1);
    % tpr = tp / (tp+fp)
    tpr_eigenfaces = cv1(1)/(cv1(1)+cv1(2));
    tpr_var(i) = tpr_eigenfaces;
    fprintf(1,'TPR_{Eigenfaces}=%.2f%%\n', tpr_eigenfaces*100.0);
end

plot(vars_to_keep, tpr_var);