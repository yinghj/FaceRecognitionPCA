% Load faces
IN_FOLDER = 'orl_faces_att';
SAMPLE_CNT = 40;
FACE_CNT = 10;
h = 112; w = 92;

faces = load_faces(IN_FOLDER, SAMPLE_CNT, FACE_CNT, h*w);
[pixels, numFaces] = size(faces);

[signal, PC, V] = pca(faces);

% Pull out eigen values and vectors
eigVals = V;
eigVecs = PC;

% Plot eigenvalues
figure; plot(log(eigVals)); 
title('Eigenvalues (log) in descending order');

disp('Press any key to display mean face.')
pause;

meanFace = mean(faces, 2);

% Plot the mean sample and 
% the first 'EIGENSTOSHOW' number of principal components
figure; imshow(imresize(reshape(meanFace, h, w),3)); title('Mean Face');

disp('Press any key to display eigenfaces.')
pause;

% Define the number of eigenfaces to display
EIGENSTOSHOW = 10;
figure; 
for i = 0:EIGENSTOSHOW/2-1
    subplot(2, EIGENSTOSHOW/2, mod(i, EIGENSTOSHOW/2)+1); 
    imagesc(reshape(eigVecs(:, i+1), h, w)); colormap(gray);
    title(strcat('No. ', string(i+1),' Eigenface'));
    
    subplot(2, EIGENSTOSHOW/2, mod(i, EIGENSTOSHOW/2)+1+EIGENSTOSHOW/2); 
    imagesc(reshape(eigVecs(:, i+1+EIGENSTOSHOW/2), h, w)); colormap(gray);
    title(strcat('No. ', string(i+1+EIGENSTOSHOW/2),' Eigenface'));
end

% Define a better higher-rank (still low-rank compare to full) approx. 
% The cumulative energy content for the m'th eigenvector 
% is the sum of the energy content across eigenvalues 1:m
for i = 1:numFaces
    energy(i) = sum(eigVals(1:i));
end
propEnergy = energy./energy(end);
% Determine the number of principal components 
% required to model 90% of data variance
percentMark = find(propEnergy > 0.9, 1 );


% Pick those principal components
eigenVecs = eigVecs(:, 1:percentMark);
eigenVecs_low = eigVecs(:, 1:EIGENSTOSHOW);

% Project each faces onto the corresponding eigenfaces 
% to reconstruct the faces in lower dimension. 
person = zeros(pixels, SAMPLE_CNT);
personW = zeros(percentMark, 1);
personW_low = zeros(EIGENSTOSHOW, 1);

for i=1:SAMPLE_CNT
    person(:, i) = faces(:, (i-1)*10+1);
    personW(:, i) = eigenVecs\person(:, i);
    personW_low(:, i) = eigenVecs_low\person(:, i);
end


disp('Press any key to reconstruct faces.')
pause;

for i=1:SAMPLE_CNT
    figure;
    subplot(1, 3, 1); imagesc(reshape(person(:, i), h, w)); 
    colormap(gray);
    title(strcat('Person ', string(i),' Face'));
    
    recon_low_ = eigenVecs_low*personW_low(:, i);
    subplot(1, 3, 2); imagesc(reshape(recon_low_(:,1), h, w)); 
    colormap(gray);
    title('Reconstructed by 10 eigenfaces');
    
    recon_ = eigenVecs*personW(:, i);
    subplot(1, 3, 3); imagesc(reshape(recon_(:,1), h, w)); 
    colormap(gray);
    title('Reconstructed 90% Variance');
    
    pause;
end