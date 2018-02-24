function dataset = load_faces(input_folder, ...
    sample_cnt, face_cnt, pixel_cnt)

dataset = zeros(pixel_cnt, sample_cnt*face_cnt);
i = 1;
for f_ind = 1:sample_cnt
    subfolder = strcat(input_folder, '/s', num2str(f_ind));
    for img_ind = 1:face_cnt
        % Import a pmg image.
        path = strcat(subfolder, '/', num2str(img_ind), '.pgm');
        pic = imread(path);
        
        % Convert the image from integer entries to doubles 
        % so we can do linear algebra on it.
        graypic = im2double(pic);
        
        % Convert a pixel matrix to a column vector 
        img_vec = reshape(graypic, [], 1);
        
        % Add image vector to matrix
        dataset(:, i) = img_vec;
        i = i + 1;
    end
end