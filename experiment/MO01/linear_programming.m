function linear_programming ()
% LINEAR_PROGRAMMING Solve the illumination problem using linear programming.
%            This approach is also called Chebyshev or Minimax Approximation.
%

% load data
[m, n, A] = illum_data ();

I_des = 1; % desired illuminance
p_max = 1; % maximal luminous intensity

c = [zeros(m, 1); 1]; % objective vector
A_ = [ A, -ones(n,1);  % constraint matrix
      -A, -ones(n,1)];
b  = [ones(n, 1); -ones(n, 1)] * I_des; % constraint vector
lb = [zeros(m, 1);        -inf];        % lower bound
ub = [ones(m, 1) * p_max;  inf];        % upper bound
if (exist ('linprog', 'file') ~= 0)
  x = linprog (c, A_, b, [], [], lb, ub);
else
  ctype = repmat ('U', 2*n, 1);
  x = glpk (c, A_, b, lb, ub, ctype);
end

p = x(1:m);
t = x(end);

% display solution
fopt = max (abs (log (A * p) - log (I_des)));

figure ();
subplot (2, 1, 1);
bar (p);
axis ([0, m+1, 0, p_max]);
title ('Linear Programming: vector p');
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
disp (['Linear Programming = ', num2str(fopt)])
disp (' ')
disp ('p =')
disp (p(:)')
disp ('t =')
disp (t)

end
