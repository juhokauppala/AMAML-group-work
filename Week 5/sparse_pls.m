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



result = [];
end

function [b] = S(a, lambda)
b = sign(a) * max((abs(a) - lambda), 0);
end
