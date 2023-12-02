%% acceleration simulation utilizing Simulinks Dual Track model
% author:       Elias Niepötter
% organisation: Campus Motorsport Hannover
% role:         Alumnus

clear;
close all;
clc;

%% Define parameters for simulation/vehicle

m = 210;                        % mass [kg]
long_acc = 2100;                % longitudinal acceleration force [N]
rear_front_split = 1;           % tractive force regarding RA [-]
dist_cog_FA = 0.5;              % distance c.o.g. to FA [m]
dist_cog_RA = 0.5;              % distance c.o.g. to RA [m]
vert_dist_cog_axles = 0.05;     % vertical distance from c.o.g. to axle plnane [m]
track_FA = 1.5;                 % track width FA [m]
track_RA = 1.5;                 % track width RA [m]

aero_area = 1.5;                % aeor surface area [m^2]
cl = 2.5;                       % coefficient of lift [-]
cd = 1.3;                       % coefficient of drag [-]

yaw_polar_inertia = 2000;       % yaw polar inertia [kg*m^2]


%% run simulation

% define solver parameters
paramStruct.StopTime = 6;       % has to be above expected Accel Time [s]
paramStruct.Solver = 'ode1';    % Euler-Cauchy as solver
paramStruct.FixedStep = 0.001;  % time step for solving the IVP

out = sim('vds.slx');           % run simulation


%% analysis of results

% print basic information to console
acc_time = ['Acceleration time: ', num2str(out.tout(end)), 's'];
maxVel = ['top speed: ', num2str(out.vel(end)), 'km/h'];
disp(acc_time);
disp(maxVel);

% generate plots of simulation
figure;
tiledlayout(2, 1);
    nexttile;
    plot(out.tout, out.vel);
    title('Acceleration Event - Velocity');
    xlabel('time [s]');
    ylabel('velocity [km/h]');
    grid;
        nexttile;
        plot(out.tout, out.dist);
        title('Acceleration Event - Distance');
        xlabel('time [s]');
        ylabel('driven distance [m]');
        grid;


%% sensitivity study

% varying parameters +-10% to determine sensitivity
m_base = 210;
cd_base = 1.3;

% analysis of mass sensitivity
m = m_base;
out(1) = sim('vds.slx');
m = m_base*0.9;
out(2) = sim('vds.slx');
m = m_base*1.1;
out(3) = sim('vds.slx');

% analysis of cd sensitivity
m = m_base;
cd = cd_base;
out(4) = sim('vds.slx');
cd = cd_base*0.9;
out(5) = sim('vds.slx');
cd = cd_base*1.1;
out(6) = sim('vds.slx');


%% analysis of sensitivity

delta_t_plus10m = (out(3).tout(end) - out(1).tout(end))*1000;
delta_t_minus10m = (out(2).tout(end) - out(1).tout(end))*1000;

delta_t_plus10cd = (out(6).tout(end) - out(4).tout(end))*1000;
delta_t_minus10cd = (out(5).tout(end) - out(4).tout(end))*1000;

x = ["mass", "cd"];
y = [delta_t_plus10m, delta_t_minus10m; delta_t_plus10cd, delta_t_minus10cd];

figure;
barh(x, y, 'stacked', 'BaseValue', 0);
title('Sensitivity Study');
xlabel('delta time [ms]');
legend('+10%', '-10%');









