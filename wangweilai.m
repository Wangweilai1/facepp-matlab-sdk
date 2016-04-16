%
% Face++ Matlab SDK demo
%

clc; clear;
% Load an image, input your API_KEY & API_SECRET
img = 'GJJ.png';
API_KEY = '9c1dce6c4c8601b5344ea697a4d10de0';
API_SECRET = '7AiyBO3wjQ7ReLRP7u514GFrqPbzZSUO';

% If you have chosen Amazon as your API sever and 
% changed API_KEY&API_SECRET into yours, 
% pls reform the FACEPP call as following :
% api = facepp(API_KEY, API_SECRET, 'US')
api = facepp(API_KEY, API_SECRET);

% Detect faces in the image, obtain related information (faces, img_id, img_height, 
% img_width, session_id, url, attributes)
rst = {};
try
    rst = detect_file(api, img, 'all');
catch
    disp('Sorry, The face is error!');
    return;
end
img_width = rst{1}.img_width;
img_height = rst{1}.img_height;
total_area = img_width * img_height;
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
    
    point_pre = getfield(landmark_points, landmark_names{2}) ;
    point_end = getfield(landmark_points, landmark_names{11});
    centel_x0 = (abs(point_pre.x * img_width / 100 - point_end.x * img_width /100) / 2) + min(point_pre.x * img_width / 100, point_end.x * img_width / 100);
    centel_y0 = (abs(point_pre.y * img_height / 100 - point_end.y * img_height / 100) / 2) + min(point_pre.y * img_height / 100, point_end.y * img_height / 100);
    bottom0 = sqrt( (centel_x0 - point_pre.x * img_width / 100)^2 + (centel_y0 - point_end.y * img_height / 100)^2 );
    sqare1 = 0.5 * pi * bottom0^2;
    sqare = 0;
    for j = 2 : 19 / 2
        point_pre = getfield(landmark_points, landmark_names{j + 1});
        point_end = getfield(landmark_points, landmark_names{j + 9});
        centel_x1 = (abs(point_pre.x * img_width / 100 - point_end.x * img_width / 100) / 2) + min(point_pre.x * img_width / 100, point_end.x * img_width / 100);
        centel_y1 = (abs(point_pre.y * img_height / 100 - point_end.y * img_height / 100) / 2) + min(point_pre.y * img_height / 100, point_end.y * img_height / 100);
        bottom1 = sqrt( (centel_x1 - point_pre.x)^2 + (centel_y1 - point_end.y)^2 );
        height = sqrt( (centel_x1 - centel_x0)^2 + (centel_y1 - centel_y0)^2 );
        sqare = sqare + (bottom0 + bottom1) * height / 2;
        centel_x0 = centel_x1; centel_y0 = centel_y1;
        bottom0 = bottom1;
        %scatter(pt.x * img_width / 100, pt.y * img_height / 100, 'g.');
    end
    percentage = ( (2 * sqare + sqare1) / total_area ) * 100
    %fprintf('The face sqare is  %d !\n', percentage);
end