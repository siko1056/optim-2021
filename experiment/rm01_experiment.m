function rm02_experiment ()
  % Nonlinear objective function.
  fun = @(x) (x(1) - 3).^2 + (x(2) - 2).^2;

  % Starting point.
  x0 = [2, 1];

  % Linear inequality constraints A * x <= b.
  A = [1 2];  % g_2
  b = [4];

  % Linear equality constraints Aeq * x = beq.
  Aeq = [];
  beq = [];

  % Bounds lb <= x <= ub
  lb = [0, 0];      % g_3 and g_4
  ub = [];

  % Call solver.
  [x,fval,exitflag,output,lambda,grad,hessian] = fmincon (fun,x0,A,b,Aeq,beq,lb,ub,@nonlcon);
  
  % Display interesting details.
  
  exitflag  % == 1 success
  x         % optimal solution
  fval      % function value at optimal solution
  grad      % gradient of fun at optimal solution
  hessian   % Hessian matrix of fun at optimal solution
  lambda    % Lagrange parameter
  lambda.lower       % lambda_3 and lambda_4
  lambda.ineqlin     % lambda_2
  lambda.ineqnonlin  % lambda_1
end

% Nonlinear constraint function for g_1.
function [c,ceq] = nonlcon(x)
  c = x(1).^2 + x(2).^2 - 5;
  ceq = 0;
end
