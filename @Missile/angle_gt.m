function [alpha_gt, beta_gt, n_y, n_z] = angle_gt(mis, target)
    import utils.bin_solve
    [n_y, n_z] = mis.overload(target);
    
    f_alpha0 = @(alpha)(-n_y + (mis.push()*sin(alpha)+...
            mis.Y(mis.getv(),mis.y,alpha))/mis.m()/mis.g);
    alpha_gt = bin_solve(f_alpha0,-mis.alpha_max,mis.alpha_max);
    
    f_beta0 = @(beta)(-n_z + (-mis.push()*cos(alpha_gt)*sin(beta)+...
            mis.Y(mis.getv(),mis.y,beta))/mis.m()/mis.g);
    beta_gt = bin_solve(f_beta0,-mis.beta_max,mis.beta_max);
end