function d_var = GTDE(mis, t, var)
% GTDE for : differential equation of guided trajectory
% var : [V, theta, psi_c, x, y, z]

d_var(1) = (mis.ft_push(t)*cos(mis.alpha)*cos(mis.beta) - ...
            mis.X(var(1),var(5),mis.alpha) - mis.ft_m(t)*mis.g*sin(var(2)))/mis.ft_m(t);
d_var(2) = (mis.ft_push(t)*sin(mis.alpha) + mis.Y(var(1),var(5),mis.alpha) - ...
            mis.ft_m(t)*mis.g*cos(var(2)))/mis.ft_m(t)/var(1);
d_var(3) = (-mis.ft_push(t)*cos(mis.alpha)*sin(mis.beta) +...
            mis.Y(var(1),var(5),mis.beta))/(-mis.ft_m(t)*var(1)*cos(var(2)));
d_var(4) = var(1) * cos(var(2)) * cos(var(3));
d_var(5) = var(1) * sin(var(2));
d_var(6) = - var(1) * cos(var(2)) * sin(var(3));
end