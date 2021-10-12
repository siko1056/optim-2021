function um02_experiment ()

disp ('Step 1: plotting the problem')

f = @(x,y) x.^3 - 6.*x.*y + 8.*y.^3;

[x, y] = meshgrid (linspace (-2, 2, 20));
mesh (x, y, f(x,y));
grid on;
xlabel ('x');
ylabel ('y');
zlabel ('f(x,y)');
title ('f(x,y) = x^3 - 6xy + 8y^3');
hold on;
plot3 (1, 0.5, -1, 'ro');

view (-60, 50);


disp ('Step 2: Try fminsearch')

format long;
xpath = zeros(0, 3);  % Memorize path

x0 = [1, 1];
options.Display = 'iter';
[xopt, fval, exitflag] = fminsearch (@fun, x0, options);

disp ('Solution');
disp (xopt);

disp ('Objective value at solution');
disp (fval);

fprintf ('exitflag = %d\n', exitflag);

animate_path (xpath, {'bo-'});


disp ('Step 3: Try fminunc')

xpath = zeros(0, 3);  % Memorize path

%x0 = [1, 1];
options.Display = 'iter';
options.GradObj = 'on';
[xopt, fval, exitflag] = fminunc (@fun, x0, options);

disp ('Solution');
disp (xopt);

disp ('Objective value at solution');
disp (fval);

fprintf ('exitflag = %d\n', exitflag);

animate_path (xpath, {'go-'});


disp ('Step 4: Try newton_simple')

xpath = zeros(0, 3);  % Memorize path

%x0 = [1, 1];
options.Display = 'iter';
[xopt, fval, exitflag] = newton_simple (@fun, x0, options);

disp ('Solution');
disp (xopt);

disp ('Objective value at solution');
disp (fval);

fprintf ('exitflag = %d\n', exitflag);

animate_path (xpath, {'ro-'});


disp ('Step 5: Try nelder_mead')

xpath = zeros(0, 3);  % Memorize path

%x0 = [1, 1];
options.Display = 'iter';
options.MaxIterations = 4;
[xopt, fval, exitflag] = nelder_mead (@fun, x0, options);

disp ('Solution');
disp (xopt);

disp ('Objective value at solution');
disp (fval);

fprintf ('exitflag = %d\n', exitflag);

animate_path (xpath, {'mo-'});


% Nested function to pass to fminsearch and fminunc.

  function [fx, gx, hx] = fun (x)
    fx = x(1).^3 - 6.*x(1).*x(2) + 8.*x(2).^3;
    
    gx = [  3.*x(1).^2 - 6.*x(2); ...
           24.*x(2).^2 - 6.*x(1)  ];
    
    hx = [ 6.*x(1),       -6; ...
                -6, 48.*x(2)  ];
    
    xpath = [xpath; x(:)', fx];  % Memorize path
  end

end

function animate_path (xpath, LineSpec)
  for i = 2:size (xpath, 1)
    plot3 (xpath(i-1:i,1), xpath(i-1:i,2), xpath(i-1:i,3), LineSpec{:});
    pause (0.1);
    drawnow ();
  end
end
