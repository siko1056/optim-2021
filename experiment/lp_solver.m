function [x, fval, exitflag, output] = lp_solver (c, A, b, x0, options)
  % LP_SOLVER Solver for linear programs (LP).
  %
  %    Input:
  %
  %       min  c'*x
  %       s.t. A *x  = b
  %               x >= 0
  %
  %       x0 - initial guess
  %
  %   Output:
  %           x - solution
  %        fval - objective value at solution
  %    exitflag - 0 = no solution found
  %               1 = solution found
  %      output - struct with fields:
  %          .xpath - history of x
  %

  narginchk (3, 5);

  opt = struct ();
  if ((nargin == 5) && isstruct (options))
    opt = options;
  end
  if (~isfield (opt, 'MaxIterations') || isempty (opt.MaxIterations))
    opt.MaxIterations = 10;
  end
  if (~isfield (opt, 'Display'))
    opt.Display = 'off';
  end
  if (~isfield (opt, 'OptimalityTolerance'))
    opt.OptimalityTolerance = 1e-8;
  end

  c = c(:);
  b = b(:);
  n = length (c);
  m = length (b);

  % Hessian matrix for Newton step.
  H = @(x,s) [ zeros(n), -eye(n),          A'; ...
                diag(s), diag(x), zeros(n, m); ...
                      A,       zeros(m,n + m) ];

  % Gradient vector for Newton step.
  G = @(x,s,y,mu) [ c - s + A' * y; ...
                    x .* s - mu * ones(n, 1); ...
                    A * x - b ];

  % Initial values.  x should be an inner LP point.
  if ((nargin > 3) && ~isempty (x0))
    x = x0(:);
  else
    x = ones (n, 1);
  end
  s = ones (n, 1);
  y = ones (m, 1);
  mu = 0.1;

  % Track central path.
  output.xpath = x;

  if (strcmp (opt.Display, 'iter'))
    fprintf('Iteration   fval     ||dx||      ||dy||      ||ds||\n')
  end

  fval = c'*x;
  exitflag = 0;

  % Newton iteration.
  for i = 1:opt.MaxIterations

    % Newton step on optimality conditions.
    d = H(x,s) \ -G(x,s,y,mu);

    % Stop iteration if x does not change any more.
    if (norm (d(1:n), 'inf') < opt.OptimalityTolerance)
      if (strcmp (opt.Display, 'iter'))
        fprintf ('\nIPM converged in step %d.\n\n', i);
      end
      exitflag = 1;
      break;
    end

    % Update variables.
    x = x + d(1:n);
    s = s + d((1:n) + n);
    y = y + d((1:m) + (n * 2));

    fval = c'*x;

    mu = mu^2;  % Shrink mu fast.

    % Output step statistics.
    output.xpath(:,end+1) = x;
    if (strcmp (opt.Display, 'iter'))
      fprintf('%5d      %.2f   %.2e    %.2e    %.2e\n', ...
        i, fval, ...
        norm (d(1:n), 'inf'), ...
        norm (d((1:m) + n), 'inf'), ...
        norm (d((1:m) + (n * 2)), 'inf'));
    end
  end

  if (i == opt.MaxIterations)
    warning ('MaxIterations = %d reached.\n', opt.MaxIterations);
  end

end