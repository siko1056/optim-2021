function rm03_experiment()
  % Nonlinear objective function.
  fun = @(x) x(1) + x(2);

  % Starting point.
  x0 = [0, 0];

  % Linear inequality constraints A * x <= b.
  A = [];
  b = [];

  % Linear equality constraints Aeq * x = beq.
  Aeq = [];
  beq = [];

  % Bounds lb <= x <= ub
  lb = [];
  ub = [];

  % Call solver.
  [x,fval,exitflag,output,lambda,grad,hessian] = fmincon (fun,x0,A,b,Aeq,beq,lb,ub,@nonlcon);
  
  % Display interesting details.
  
  exitflag  % == 1 success
  output
  x         % optimal solution
  fval      % function value at optimal solution
  grad      % gradient of fun at optimal solution
  hessian   % Hessian matrix of fun at optimal solution
  lambda    % Lagrange parameter
  lambda.eqnonlin  % lambda_1 and lambda_2
  
  disp ('"="-Constraints')
  [(x(1) - 1).^2 + x(2).^2 - 1; ...
   (x(1) - 2).^2 + x(2).^2 - 4]
end

% Nonlinear constraint function for g_1.
function [c,ceq] = nonlcon(x)
  c = 0;
  ceq = [(x(1) - 1).^2 + x(2).^2 - 1; ...
         (x(1) - 2).^2 + x(2).^2 - 4];
end
