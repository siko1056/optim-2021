function [x, fval, exitflag] = newton_simple (fun, x0, options)
  % Find minimum of unconstrained multivariable function.
  %
  %   Input:
  %         fun - function (returning function value, gradient
  %               vector value and Hessian matrix value)
  %          x0 - initial guess
  %     options - structure with fields
  %       .MaxIterations       - max. number of iterations
  %       .OptimalityTolerance - tolerance for the norm of gradient
  %       .Display             - display details for 'iter'
  %
  %   Output:
  %           x - solution
  %        fval - objective value at solution
  %    exitflag - 0 = no solution found
  %               1 = solution found
  %

  narginchk(2,3);

  opt = struct ();
  if ((nargin == 3) && isstruct (options))
    opt = options;
  end
  if (~isfield (opt, 'MaxIterations') || isempty (opt.MaxIterations))
    opt.MaxIterations = 30;
  end
  if (~isfield (opt, 'Display'))
    opt.Display = 'off';
  end
  if (~isfield (opt, 'OptimalityTolerance'))
    opt.OptimalityTolerance = 1e-9;
  end
  if (strcmp(opt.Display, 'iter'))
    fprintf('Iteration\tStep-size\tf(x)\t\t||df(x)||\n')
  end

  exitflag = 0;
  x = x0(:);
  i = 0;
  while (i < opt.MaxIterations)
    [fval, fgrad, fhess] = fun(x);
    if (norm (fgrad, 'inf') < opt.OptimalityTolerance)
      exitflag = 1;  % success!
      return;
    end
    d = fhess \ -fgrad;
    if (strcmp (opt.Display, 'iter'))
      fprintf('%5d\t\t%e\t%e\t%e\n', i, norm (d, 'inf'), ...
        fval, norm (fgrad, 'inf'));
    end
    x = x + d;
    i = i + 1;
  end

  if (i >= opt.MaxIterations)
    warning ('MaxIterations = %d reached.\n', opt.MaxIterations);
  end
end
