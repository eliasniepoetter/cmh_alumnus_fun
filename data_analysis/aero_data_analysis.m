% author: Elias Niepoetter

close all;
clear;
clc;



%% load data and preliminaries

data = readtable('Faįberg_Sami_Testing_P23_20240409_12_50_Aero.csv');
sampleTime = 0.01;
time = 0:sampleTime:(length(data.Time)*sampleTime)-sampleTime;
clc;


%% velocity trace

v = data.GPSSpeed_kph_;
figure;
hold on;
title('velocity trace');
plot(time,v);
xlabel('time [s]');
ylabel('velocity [m/s]');
grid on;
hold off;



%% Aero Sensor

% Apply Moving Average to smooth signal
movingAverageHorizon = 50;
ae_sensors = zeros(16,length(time));

ae_sensors(1,:) = movmean(data.Aero_Press1_mbar_,movingAverageHorizon);
ae_sensors(2,:) = movmean(data.Aero_Press2_mbar_,movingAverageHorizon);
ae_sensors(3,:) = movmean(data.Aero_Press3_mbar_,movingAverageHorizon);
ae_sensors(4,:) = movmean(data.Aero_Press4_mbar_,movingAverageHorizon);
ae_sensors(5,:) = movmean(data.Aero_Press5_mbar_,movingAverageHorizon);
ae_sensors(6,:) = movmean(data.Aero_Press6_mbar_,movingAverageHorizon);
ae_sensors(7,:) = movmean(data.Aero_Press7_mbar_,movingAverageHorizon);
ae_sensors(8,:) = movmean(data.Aero_Press8_mbar_,movingAverageHorizon);
ae_sensors(9,:) = movmean(data.Aero_Press9_mbar_,movingAverageHorizon);
ae_sensors(10,:) = movmean(data.Aero_Press10_mbar_,movingAverageHorizon);
ae_sensors(11,:) = movmean(data.Aero_Press11_mbar_,movingAverageHorizon);
ae_sensors(12,:) = movmean(data.Aero_Press12_mbar_,movingAverageHorizon);
ae_sensors(13,:) = movmean(data.Aero_Press13_mbar_,movingAverageHorizon);
ae_sensors(14,:) = movmean(data.Aero_Press14_mbar_,movingAverageHorizon);
ae_sensors(15,:) = movmean(data.Aero_Press15_mbar_,movingAverageHorizon);
ae_sensors(16,:) = movmean(data.Aero_Press16_mbar_,movingAverageHorizon);

% postprocessing
for i = 1 : 16
    ae_sensors(i,:) = ae_sensors(i,:)*100; % to get Pascal as SI-Unit
end


% caclulate average static pressure when vehicle is standing
averageHorizon = 30; % in seconds
staticAverageS10 = sum(ae_sensors(10,1:(averageHorizon/sampleTime)))/(averageHorizon/sampleTime);


% diffusor outer channel flow: Sensor 10, 13, 14, 15
figure;
tiledlayout(2,1);
nexttile;
hold on;
title('velocity trace');
plot(time,v);
xlabel('time [s]');
ylabel('velocity [km/h]');
grid on;
hold off;

nexttile;
hold on;
title('aero sensor measurement (Sensor 10)');
plot(time, ae_sensors(10,:));
xlabel('time [s]');
ylabel('Absolute Pressure [Pa]');
grid on;
hold off;


%% All Sensors

figure;
hold on;
title('All Sensor Data');
for i = 1 : 16
    plot(time, ae_sensors(i,:));
end
grid on;
xlabel('time [s]');
ylabel('Absolute Pressure [Pa]');
hold off;





