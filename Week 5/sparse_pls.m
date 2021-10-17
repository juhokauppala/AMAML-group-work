function [result] = sparse_pls(data)
%SPLS Sparse Partial Least Squares
%   https://doi.org/10.1016/j.jneumeth.2016.06.011
%   Example solution based on the same article:
%   https://github.com/jmmonteiro/spls/blob/master/spls.m
%
%   The example solution is used in advisory manner while writing this code.

% 2.2.1. SPLS algorithm
X = data(:,1:end-1);
Y = data(:,end);

%[u, v, success] = my_spls(X, Y, sqrt(21), 1);
[u, v, success] = spls(X, Y, sqrt(21), 1);
if ~success
    warning('SPLS not successful');
end

estimates = sum(X .* u', 2);
disp("SPLS stats:");
total_var = sum((Y - mean(Y)).^2)
residuals = sum((estimates - Y).^2)
r2 = 1 - (residuals / total_var)
result = [];
end

function [b] = S(a, lambda)
b = sign(a) * max((abs(a) - lambda), 0);
end

% UNFINISHED
function [U_out, V_out] = iterate(V, C)
U_new = C * V;
end

% UNFINISHED - DO NOT USE YET
function [u, v, success] = my_spls(X, Y, su, sv)
% 1 Let C <- X'Y
C = X' * Y;

% 2 Initialize v to have norm(v, 2) = 1
[U, ~, V] = svd(X);
U = U(:, 1) ./ norm(U(:, 1));
V = V(:, 1) ./ norm(V(:, 1));

if (norm(V, 2) ~= 1)
    warning('Sparse PLS: SVD initialization failed');
end

% 3 Repeat until convergence
is_ready = false;
while ~is_ready
    [u, v] = iterate(V, C);
end
success = false;
end