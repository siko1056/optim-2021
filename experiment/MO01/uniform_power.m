function uniform_power ()
% UNIFORM_POWER Solve the illumination problem using a uniform power vector.
%

% load data
[m, n, A] = illum_data ();

I_des = 1; % desired illuminance
p_max = 1; % maximal luminous intensity

% optimal p
p_opt = 0.3454;

p = ones (m, 1) * p_opt;

% display solution
fopt = max (abs (log (A * p) - log (I_des)));

subplot (2, 1, 1);
bar (p);
axis ([0, m+1, 0, p_max]);
title ('Uniform power: vector p');
subplot (2, 1, 2);
bar (A * p);
hold on;
plot ([0, n+1], [I_des, I_des], 'r');
hold off;
axis ([0, n+1, 0, 5]);
title (['Patch intensities I, f_{opt} = ', num2str(fopt)]);

p_label = uicontrol ('Style', 'text', 'Position', [250 1 120 20], 'String', ...
    ['p = ' num2str(p_opt)]);
uicontrol ('Style', 'slider', 'Min', 0, 'Max', p_max, 'Value', p_opt, ...
    'Position', [50 1 200 20], 'Callback', ...
    {@power_adjust, {p_label, m, n, A, I_des, p_max}});
end


function [] = power_adjust (hObj, ~, data)
% POWER_ADJUST Solution of the illumination problem using a constant vector.
%

p_label = data{1};
m = data{2};
n = data{3};
A = data{4};
I_des = data{5};
p_max = data{6};

p = ones (m, 1) * get (hObj, 'Value');

% display solution
fopt = max (abs (log (A * p) - log (I_des)));

subplot (2, 1, 1);
bar (p);
axis ([0, m+1, 0, p_max]);
title ('Uniform power: vector p');
subplot (2, 1, 2);
bar (A * p);
hold on;
plot ([0, n+1], [I_des, I_des], 'r');
hold off;
axis ([0, n+1, 0, 5]);
title (['Patch intensities I, f_{opt} = ', num2str(fopt)]);

set(p_label , 'String', ['p = ' num2str(get(hObj,'Value'))]);
end
