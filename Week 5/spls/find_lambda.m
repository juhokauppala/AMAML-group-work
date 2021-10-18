function [lambda, U] = find_lambda(U, c_u)
fn = @(U, lambda) S(U, lambda) ./ norm(S(U, lambda));

lambda = min(maxk(abs(U), 2));
step = lambda / 2;
norm_value = norm(fn(U, lambda), 1);

while (norm_value - c_u)^2 > 1e-10
    % Larger lambda => smaller norm_value
    if norm_value > c_u
        lambda = lambda + step;
    else
        lambda = lambda - step;
    end
    step = step / 2;
    
    norm_value = norm(fn(U, lambda), 1);
end

U = fn(U, lambda);
end

% This function gets stuck in infinite loop if norm_value > c_u on the very
% first iteration, which means that function shouldn't have been called in
% the first place...