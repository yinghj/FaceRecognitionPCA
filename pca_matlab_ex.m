% From http://www.mathworks.com/help/stats/pca.html
load cities;
% In total, the cities data set contains three variables:
% categories, a character matrix containing the names of the indices
% names, a character matrix containing the 329 city names
% ratings, the data matrix with 329 rows and 9 columns

categories

figure()
boxplot(ratings,'orientation','horizontal','labels',categories)

% Check the pairwise correlation between the variables.
C = corr(ratings,ratings);
% 
% Compute principal components.
% When all variables are in the same unit, 
% it is appropriate to compute principal components for raw data. 

% When the variables are in different units or 
% the difference in the variance of different columns is substantial 
% (as in this case), scaling of the data or use of weights is often preferable.

% Perform the principal component analysis 
% by using the inverse variances of the ratings as weights.
w = 1./var(ratings);
[wcoeff,score,latent,tsquared,explained] = pca(ratings,...
'VariableWeights',w);


% Component coefficients.
% The first output, wcoeff, contains the coefficients 
% of the principal components.
% These coefficients are weighted, 
% hence the coefficient matrix is not orthonormal.

% The first three principal component coefficient vectors are:
c3 = wcoeff(:,1:3);

% Transform coefficients.
% Transform the coefficients so that they are orthonormal.
coefforth = diag(sqrt(w))*wcoeff;
% Check coefficients are orthonormal.
% The transformed coefficients are now orthonormal.
I = coefforth'*coefforth;


% Component scores.
% The second output, score, contains 
% the coordinates of the original data in the new coordinate system 
% defined by the principal components. 
% The score matrix is the same size as the input data matrix. 
% You can also obtain the component scores 
% using the orthonormal coefficients 
% and the standardized ratings as follows.
cscores = zscore(ratings)*coefforth;

% Plot component scores.
% Create a plot of the first two columns of score.
figure()
plot(score(:,1),score(:,2),'+')
xlabel('1st Principal Component')
ylabel('2nd Principal Component')

% Interactive graph: 
% Note the outlying points in the right half of the plot. 
% You can graphically identify these points as follows.
% Move your cursor over the plot 
% and click once near the rightmost seven points. 
% This labels the points by their row numbers as in the following figure.

% gname

% Extract observation names.
% Create an index variable containing the row numbers 
% of all the cities you chose and get the names of the cities.
metro = [43 65 179 213 234 270 314];
names(metro,:)
% These labeled cities are some of the biggest population centers 
% in the United States and they appear more extreme than 
% the remainder of the data.

% Component variances.
% The third output, latent, is a vector containing the variance 
% explained by the corresponding principal component. 
% Each column of score has a sample variance equal 
% to the corresponding row of latent.
% Percent variance explained.
% The fifth output, explained, is a vector containing the percent variance 
% explained by the corresponding principal component.

% Create scree plot.
% Make a scree plot of the percent variability explained by 
% each principal component.
figure()
pareto(explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')
% This scree plot only shows the first seven (instead of the total nine) 
% components that explain 95% of the total variance. 
% The only clear break in the amount of variance accounted for 
% by each component is between the first and second components. 
% However, the first component by itself explains less than 40% of 
% the variance, so more components might be needed. 
% You can see that the first three principal components explain roughly 
% two-thirds of the total variability in the standardized ratings, 
% so that might be a reasonable way to reduce the dimensions.


% Hotelling's T-squared statistic.
% The last output from pca is tsquared, which is Hotelling's T2, 
% a statistical measure of the multivariate distance of each observation 
% from the center of the data set. 
% This is an analytical way to find the most extreme points in the data.
[st2,index] = sort(tsquared,'descend'); % sort in descending order
extreme = index(1);
names(extreme,:)

% Visualize the results.
% Visualize both the orthonormal principal component coefficients 
% for each variable and the principal component scores for each observation
% in a single plot.
biplot(coefforth(:,1:2),'scores',score(:,1:2),'varlabels',categories);
axis([-.26 0.6 -.51 .51]);
% All nine variables are represented in this bi-plot by a vector, 
% and the direction and length of the vector indicate how each variable 
% contributes to the two principal components in the plot. 

% For example, the first principal component, on the horizontal axis, 
% has positive coefficients for all nine variables. 
% That is why the nine vectors are directed into the right half of the plot.
% The largest coefficients in the first principal component are the third 
% and seventh elements, corresponding to the variables health and arts.

% The second principal component, on the vertical axis, has positive 
% coefficients for the variables education, health, arts, 
% and transportation, and negative coefficients for 
% the remaining five variables. 
% This indicates that the second component distinguishes among cities 
% that have high values for the first set of variables 
% and low for the second, and cities that have the opposite.

% The variable labels in this figure are somewhat crowded. 
% You can either exclude the VarLabels parameter when making the plot, 
% or select and drag some of the labels to better positions 
% using the Edit Plot tool from the figure window toolbar.

% This 2-D bi-plot also includes a point for each of the 329 observations, 
% with coordinates indicating the score of each observation for 
% the two principal components in the plot. 
% For example, points near the left edge of this plot have 
% the lowest scores for the first principal component. 
% The points are scaled with respect to the maximum score value 
% and maximum coefficient length, so only their relative locations 
% can be determined from the plot.

% You can identify items in the plot by selecting Tools>Data Cursor 
% from the figure window. By clicking a variable (vector), 
% you can read that variable's coefficients for each principal component. 
% By clicking an observation (point), you can read that observation's 
% scores for each principal component.


% Create a three-dimensional bi-plot.
% You can also make a bi-plot in three dimensions.
figure()
biplot(coefforth(:,1:3),'scores',score(:,1:3),'obslabels',names);
axis([-.26 0.8 -.51 .51 -.61 .81]);
view([30 40]);
% This graph is useful if the first two principal coordinates do not 
% explain enough of the variance in your data. 
% You can also rotate the figure to see it from different angles 
% by selecting theTools> Rotate 3D.