function least_squares ()
% LEAST_SQUARES Solve the illumination problem using least squares (+clipping).
%

% load data
[m, n, A] = illum_data ();

I_des = 1; % desired illuminance
p_max = 1; % maximal luminous intensity

b = ones(n, 1) * I_des;
p = A \ b;

% display solution
fopt = max (abs (log (A * p) - log (I_des)));

figure ();
subplot (2, 1, 1);
bar (p);
xlim ([0, m+1]);
title ('Least squares: vector p');
subplot (2, 1, 2);
bar (A * p);
hold on;
plot ([0, n+1], [I_des, I_des], 'r');
hold off;
axis ([0, n+1, 0, 5]);
title(['Patch intensities I, f_{opt} = ', num2str(fopt)]);

% console output
disp (' ')
disp (' ')
disp (['Least squares = ', num2str(fopt)])
disp (' ')
disp ('p =')
disp (p(:)')

% Clipping
p(p < 0) = 0;
p(p > p_max) = p_max;

% display solution
fopt = max (abs (log (A * p) - log (I_des)));

figure ();
subplot (2, 1, 1);
bar (p);
axis ([0, m+1, 0, p_max+1]);
title ('Least squares (clipping): vector p');
subplot (2, 1, 2);
bar (A * p);
hold on;
plot ([0, n+1], [I_des, I_des], 'r');
hold off;
axis ([0, n+1, 0, 5]);
title(['Patch intensities I, f_{opt} = ', num2str(fopt)]);

% console output
disp (' ')
disp (' ')
disp (['Least squares (clipping) = ', num2str(fopt)])
disp (' ')
disp ('p =')
disp (p(:)')

end
