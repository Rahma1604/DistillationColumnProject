function [x, iter] = newton_raphson(K, x0, y, tolerance, max_iter)
    % phase_equilibrium calculates the equilibrium concentration in the liquid phase
    % using the Newton-Raphson method.
    % Inputs:
    %   K          - Distribution coefficient (K = y/x)
    %   x0         - Initial guess for liquid phase concentration
    %   y          - Concentration in the vapor phase (constant)
    %   tolerance  - Desired accuracy for convergence
    %   max_iter   - Maximum number of iterations allowed
    %
    % Outputs:
    %   x          - Equilibrium concentration in the liquid phase
    %   iter       - Number of iterations performed

    % Define the function f(x) and its derivative f'(x)
    f = @(x) K * x - y;  % f(x) = K * x - y
    f_prime = @(x) K;    % Derivative f'(x) = K

    % Initialize variables
    x = x0;        % Initial guess for liquid phase concentration
    iter = 0;      % Iteration counter

    % Apply the Newton-Raphson method
    while iter < max_iter
        x_new = x - f(x) / f_prime(x);  % Apply the iteration

        % Check for convergence
        if abs(x_new - x) < tolerance
            x = x_new;  % Update the solution
            break;      % Exit loop if converged
        end

        x = x_new;  % Update x for the next iteration
        iter = iter + 1;  % Increment iteration count
    end
    

    % Display a message if the solution did not converge
    if iter == max_iter
        disp('Warning: Maximum iterations reached without convergence.');
    end

end
