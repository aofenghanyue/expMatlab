function err = ga_mis2tar(opti_param)
% 优化输入的参�?
    alpha = opti_param;
    beta = 0;
    [~,~,err] = mis2tar(alpha, beta);
end