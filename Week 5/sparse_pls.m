function [result] = sparse_pls(data)
%SPLS Sparse Partial Least Squares
%   https://doi.org/10.1016/j.jneumeth.2016.06.011
%   Example solution based on the same article:
%   https://github.com/jmmonteiro/spls/blob/master/spls.m
%
%   The example solution is used in advisory manner while writing this code.
addpath("Week 5/spls");

% 2.2.1. SPLS algorithm
X = data(:,1:end-1);
Y = data(:,end);

runs = 6;
result = zeros(runs, 2);
c_us = linspace(1, sqrt(size(X, 2)), runs);
for c_u_i = 1:length(c_us)
    c_u = c_us(c_u_i);
    
    % This is the open source implementation by Joao Monteiro under GNU
    % General Public Licence
    % [u, v] = spls(X, Y, c_u, 1);
    
    % This is our own implementation
    [u, v] = my_spls(X, Y, c_u, 1);
    
    if v ~= 1, disp(v), end

    estimates = sum(X .* u', 2);
    total_var = sum((Y - mean(Y)).^2);
    residuals = sum((estimates - Y).^2);
    r2 = 1 - (residuals / total_var);
    
    result(c_u_i, :) = [c_u, r2];
end
sparse_pls_results = table(result(:, 1), result(:, 2), 'VariableNames', {'c_u', 'R2'})
end

function [u, v] = my_spls(X, Y, c_u, c_v)
% 1 Let C <- X'Y
C = X' * Y;

% 2 Initialize v to have norm(v, 2) = 1
[U, ~, V] = svd(C);
U = U(:, 1) ./ norm(U(:, 1));
V = V(:, 1) ./ norm(V(:, 1));

if (norm(V, 2) ~= 1)
    warning('Sparse PLS: SVD initialization failed');
end

% 3 Repeat until convergence
is_ready = false;
while ~is_ready
    [u, v] = update_uv(V, C, c_u, c_v);
    
    greater_change = max(norm(U - u), norm(V - v));
    
    U = u;
    V = v;
    is_ready = greater_change < 1e-5;
end
end

