function convex_cvx ()
% CONVEX_CXV Solve the illumination problem using convex programming.
%            CVX modelling language http://cvxr.com/cvx/.
%

% load data
[m, n, A] = illum_data ();

I_des = 1; % desired illuminance
p_max = 1; % maximal luminous intensity

cvx_solver sdpt3

cvx_begin
  variable p(m) nonnegative;
  minimize( max (max ([A * p / I_des; inv_pos(A * p / I_des)])) );
  subject to
    p <= p_max;
cvx_end

% display solution
fopt = max (abs (log (A * p) - log (I_des)));

figure ();
subplot (2, 1, 1);
bar (p);
axis ([0, m+1, 0, p_max]);
title ('Convex optimization with CVX: vector p');
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
disp (['Convex optimization with CVX = ', num2str(fopt)])
disp (' ')
disp ('p =')
disp (p(:)')

end
