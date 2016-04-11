%
% Face++ Matlab SDK demo
%

clc; clear;
% Load an image, input your API_KEY & API_SECRET
img = 'demo.jpg';
API_KEY = 'd45344602f6ffd77baeab05b99fb7730';
API_SECRET = 'jKb9XJ_GQ5cKs0QOk6Cj1HordHFBWrgL';

% If you have chosen Amazon as your API sever and 
% changed API_KEY&API_SECRET into yours, 
% pls reform the FACEPP call as following :
% api = facepp(API_KEY, API_SECRET, 'US')
api = facepp(API_KEY, API_SECRET);

% Detect faces in the image, obtain related information (faces, img_id, img_height, 
% img_width, session_id, url, attributes)
rst = detect_file(api, img, 'all');
img_width = rst{1}.img_width;
img_height = rst{1}.img_height;
face = rst{1}.face;
fprintf('Totally %d faces detected!\n', length(face));

im = imread(img);
imshow(im);
hold on;

for i = 1 : length(face)
    % Draw face rectangle on the image
    face_i = face{i};
    center = face_i.position.center;
    w = face_i.position.width / 100 * img_width;
    h = face_i.position.height / 100 * img_height;
    rectangle('Position', ...
        [center.x * img_width / 100 -  w/2, center.y * img_height / 100 - h/2, w, h], ...
        'Curvature', 0.4, 'LineWidth',2, 'EdgeColor', 'blue');
    
    % Detect facial key points
    rst2 = api.landmark(face_i.face_id, '83p');
    landmark_points = rst2{1}.result{1}.landmark;
    landmark_names = fieldnames(landmark_points);
    
    % Draw facial key points
    fac_left_x = 0;
    fac_left_y = 0;
    fac_right_x = 0;
    fac_right_y = 0;
    for j = 1 : length(landmark_names)
        pt = getfield(landmark_points, landmark_names{j});
        if ( strcmp(landmark_names{j}, 'contour_left1') == 1 || strcmp(landmark_names{j}, 'contour_left2') == 1 ...
                || strcmp(landmark_names{j}, 'contour_left3') == 1)
            fac_left_x = fac_left_x + pt.x
            fac_left_y = fac_left_y + pt.y;
        else if ( strcmp(landmark_names{j}, 'contour_right1') == 1 || strcmp(landmark_names{j}, 'contour_right2') == 1 ...
                || strcmp(landmark_names{j}, 'contour_right3') == 1)
            fac_right_x = fac_right_x + pt.x;
            fac_right_y = fac_right_y + pt.y;
            end
        end
        scatter(pt.x * img_width / 100, pt.y * img_height / 100, 'g.');
    end
    fac_left_x = fac_left_x / 3;
    fac_left_y = fac_left_y / 3;
    fac_right_x = fac_right_x / 3;
    fac_right_y = fac_right_y / 3;
    sqrt_x = power(abs(fac_right_x - fac_left_x), 2);
    sqrt_y = power(abs(fac_right_y - fac_left_y), 2);
    fac_width = sqrt(sqrt_x + sqrt_y)
end