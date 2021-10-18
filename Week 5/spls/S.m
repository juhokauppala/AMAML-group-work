function [b] = S(a, lambda)
b = sign(a) .* max((abs(a) - lambda), 0);
end