function [U_out, V_out] = update_uv(V, C, c_u, c_v)
U_new = C * V;

U_new_0 = S(U_new, 0) ./ norm(S(U_new, 0));
is_U0_ok = norm(U_new_0, 1) <= c_u;

if is_U0_ok
    U_out = U_new_0;
else
    [~, U_out] = find_lambda(U_new, c_u);
end

V_new = C' * U_out;

V_new_0 = S(V_new, 0) ./ norm(S(V_new, 0));
is_V0_ok = norm(V_new_0, 1) <= c_v;

if is_V0_ok
    V_out = V_new_0;
else
    [~, V_out] = find_lambda(V_new, c_v);
end
end