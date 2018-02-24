function C = eigenfaces_predict(Xtrain, eigenfaces, mean, ...
    Xtest, Ytrain, k)
	%%	Predicts nearest neighbor for given Eigenfaces model.
	%%
	%%	Args:
	%%		Xtrain [pixel x num_faces] training matrix that produces the 
    %%              eigenfaces and reference for classification
    %%      eigenfaces [pixel x dim] basis of the new face space
    %%      mean [pixel x 1] the mean face of all training data
	%%		Xtest [dim x 1] test vector to predict
    %%      numClasses [int] the number of faces you want to recognize
    %%      k [int] k in knn
	test_proj = eigenfaces \ (Xtest - mean);
    train_proj = eigenfaces \ (Xtrain - repmat(mean, 1, size(Xtrain,2)));
        
	C = knn(train_proj, Ytrain, test_proj, k);
end