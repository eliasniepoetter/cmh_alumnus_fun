% author: Elias Niepoetter

close all;
clear;
clc;


%% load data

% insert correct log-file name (must be located ina  folder in your PATH)
data = readtable('59F87764.csv');  
clc;


%% Histogram for corner radius

% formula = r = v^2/ay
% Rechtskurve positiv
% Linkskurve negativ

v = data.GPSSpeed_kph_;
v_ms = v/3.6;
ay = data.ACCLat_g_*9.81;
r = v_ms.^2./ay;
r(abs(r)>50) = [];
r(abs(r)<3) = [];

histogram(r, 100);
grid on;
xline(-10, 'LineWidth', 2, 'Color', 'black');   % manually selected
xline(15, 'LineWidth', 2, 'Color', 'red');      % manually selected
title('Cornering Radius FSA 22');
xlabel('corner radius [m]');
ylabel('frequency');
legend('', 'left turn peak', 'right turn peak');


%% Heatmap for corner Radius

v = data.GPSSpeed_kph_;
v_ms = v/3.6;
ay = data.ACCLat_g_*9.81;
r = v_ms.^2./ay;
heatmapData = [r, v_ms];

lim = length(r);
for i = 1 : lim
    if abs(heatmapData(i, 1)) > 50
        heatmapData(i, :) = [0, 0];
    end
    if abs(heatmapData(i, 1)) < 3
        heatmapData(i, :) = [0, 0];
    end
end

rHM = nonzeros(heatmapData(:, 1));
vHM = nonzeros(heatmapData(:, 2));

H = [rHM, vHM];

v_edges = 2:1:20;
r_edges = -50:5:50;
H(:, 1) = discretize(H(:, 1), r_edges);
H(:, 2) = discretize(H(:, 2), v_edges);

H = array2table(H,...
    'VariableNames',{'radius','velocity'});
h = heatmap(H, 'radius', 'velocity');






