function convex_yalmip ()
% CONVEX_YALMIP Solve the illumination problem using convex programming.
%               YALMIP modelling language https://yalmip.github.io/.
%

% load data
[m, n, A] = illum_data ();

I_des = 1; % desired illuminance
p_max = 1; % maximal luminous intensity

p = sdpvar (m, 1, 'full');

%Objective = sum ((A * p - I_des).^2);
Objective = max (max ([A * p / I_des; max(1 ./ (A * p / I_des), 0)]));
Constraints = 0 <= p <= p_max;

optimize (Constraints, Objective);

% display solution
p = value (p);
fopt = max (abs (log (A * p) - log (I_des)));

figure ();
subplot (2, 1, 1);
bar (p);
axis ([0, m+1, 0, p_max]);
title ('Convex optimization with YALMIP: vector p');
subplot (2, 1, 2);
bar (A * p);
hold on;
plot ([0, n+1], [I_des, I_des], 'r');
hold off;
axis ([0, n+1, 0, 5]);
title (['Patch intensities I, f_{opt} = ', num2str(fopt)]);

% console output
disp (' ')
disp (' ')
disp (['Convex optimization with YALMIP = ', num2str(fopt)])
disp (' ')
disp ('p =')
disp (p(:)')

end
