function eigenVecs = eigenfaces(faces, var)

    [signal, PC, V] = pca(faces);

    % Pull out eigen values and vectors
    eigVals = V;
    eigVecs = PC;
    
    for i = 1:size(eigVals,1)
        energy(i) = sum(eigVals(1:i));
    end
    propEnergy = energy./energy(end);
    % Determine the number of principal components 
    % required to model 90% of data variance
    percentMark = find(propEnergy > var, 1 );


    % Pick those principal components
    eigenVecs = eigVecs(:, 1:percentMark);
end

