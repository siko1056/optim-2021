function [x, fval, exitflag] = nelder_mead (fun, x0, options)
% Find minimum of unconstrained multivariable function.
%
%   Input:
%         fun - function
%          x0 - initial guess
%     options - structure with fields
%       .MaxIterations  - max. number of iterations
%       .TolFun         - tolerance for function values
%       .Display        - display details   for 'iter',
%                         display animation for 'full'.
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
  if (~isfield (opt, 'TolFun'))
    opt.TolFun = 1e-9;
  end
  if (strcmp(opt.Display, 'iter') || strcmp (opt.Display, 'full'))
    disp (' Iteration   Func-count     min f(x)         Procedure');
    h1 = [];
    h2 = [];
    h3 = [];
  end

  exitflag = 0;

  % Parameter, here constant.
  alpha = 1;
  beta = 2;
  gamma = 0.5;
  len = 1;

  % Create start simplex.

  n = length (x0);
  p = (len / sqrt (2)) * (sqrt (n + 1) - 1) / n;
  q = [zeros(n,1), ones(n) * p];
  x = repmat (x0(:), 1, n + 1) + q ...
    + [zeros(n,1), (len / sqrt (2)) * eye(n)];

  % Compute all function values.

  fvals = zeros (1, n + 1);
  for i = 1:(n + 1)
    fvals(i) = fun(x(:,i));
  end
  fcount = n + 1;

  % Sort simplex (left is best).

  [fvals, idx] = sort (fvals);
  x = x(:,idx);

  i = 0;
  while (i < opt.MaxIterations)

    % Compute centroid.
    m = sum(x(:,1:n), 2) / n;

    % Compute reflect.
    r =  m + alpha * (m - x(:,end));
    fr = fun(r);
    fcount = fcount + 1;

    if (strcmp (opt.Display, 'full'))
      delete (h1);
      delete (h2);
      delete (h3);
      h1 = plot3 ([x(1,:), x(1,1)], [x(2,:), x(2,1)], [fvals, fvals(1)]);
      h2 = plot3 (x(1,1), x(2,1), fvals(1), 'ro');
      h3 = plot3 ([x(1,end), r(1)], [x(2,end), r(2)], [fvals(end), fr], 'go-');
      pause;
    end

    if (fr <= fvals(2))  % Case 1: reflect

      if (fr < fvals(1))  % Case 2: expand

        e = m + beta * (m - x(:,end));
        fe = fun(e);
        fcount = fcount + 1;

        if (fe < fr)  % Expansion successful =)
          r = e;
          fr = fe;
        end

        % Replace worst x(:,end) with r (or s).
        x = [r, x(:,1:n)];
        fvals = [fr, fvals(1:n)];

        step_method = 'expand';

      else

        % Replace worst x(:,end) with r.
        x = [x(:,1), r, x(:,2:n)];
        fvals = [fvals(1), fr, fvals(2:n)];

        step_method = 'reflect';

      end

    else  % Case 3: Contract / Shrink

      if (fr > fvals(end))
        step_method = 'contract inside';
        c = m - gamma * (m - x(:,end));
      else
        step_method = 'contract outside';
        c = m + gamma * (m - x(:,end));
      end

      fc = fun(c);
      fcount = fcount + 1;

      if (fc < fvals(end))

        % Replace worst x(:,end) with c.
        x = [x(:,1:n), c];
        fvals = [fvals(1:n), fc];

      else

        step_method = 'shrink';

        x = (x + repmat (x(:,1), 1, n + 1)) / 2;

        % Compute new function values again.
        for i = 1:(n + 1)
          fvals(i) = fun(x(:,i));
        end
        fcount = fcount + n + 1;

      end

      % Sort again.
      [fvals, idx] = sort (fvals);
      x = x(:,idx);

    end

    fval = fvals(1);

    if (strcmp (opt.Display, 'iter') || strcmp (opt.Display, 'full'))
      fprintf ('    %2d           %2d        %+8f         %s\n', ...
        i, fcount, fval, step_method);
    end

    % Check stopping criteria.
    if (var (fvals) < opt.TolFun)
      x = x(:,1)';
      exitflag = 1;  % success!
      return;
    end

    i = i + 1;

  end

  x = x(:,1)';

  if (i >= opt.MaxIterations)
    warning ('MaxIterations = %d reached.\n', opt.MaxIterations);
  end
end
