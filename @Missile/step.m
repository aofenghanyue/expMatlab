function mis = step(mis, tar, method)
% ����method�����֣��Ի����һ��������״̬
% method = 0 : ������������
% method = 1 : ������������

    n = round(mis.t/mis.step_time) + 1;
    if method == 0
        mis = step_project(mis, n);
    else
        mis = step_guide(mis, tar, n);
    end
end

function mis = step_project(mis, n)
% ��������
    mis.alpha = mis.ft_alpha(mis.t);
    mis.beta = mis.ft_beta(mis.t);
    var = [mis.V, mis.theta, mis.psi_c, mis.x, mis.y, mis.z];
    mis.traj(8,n) = mis.alpha;
    mis.traj(9,n) = mis.beta;
    
    import utils.RK4_1
    mis.traj(2:7,n+1) = RK4_1(@mis.GTDE, mis.t, var, mis.step_time);
    mis.t = mis.t + mis.step_time;
    mis.V = mis.traj(2,n+1);
    mis.theta = mis.traj(3,n+1);
    mis.psi_c = mis.traj(4,n+1);
    mis.x = mis.traj(5,n+1);
    mis.y = mis.traj(6,n+1);
    mis.z = mis.traj(7,n+1);
    mis.traj(1,n+1) = mis.t;
    mis = mis.set_v();
    
end

function mis = step_guide(mis, tar, n)
% ��������
    [alpha_gt, beta_gt, n_y, n_z] = mis.angle_gt(tar);
    mis.alpha = alpha_gt;
    mis.beta = beta_gt;
    var = [mis.V, mis.theta, mis.psi_c, mis.x, mis.y, mis.z];
    mis.traj(8,n) = mis.alpha;
    mis.traj(9,n) = mis.beta;
    mis.traj(10,n) = n_y;
    mis.traj(11,n) = n_z;
    
    import utils.RK4_1
    mis.traj(2:7,n+1) = RK4_1(@mis.GTDE, mis.t, var, mis.step_time);
    mis.t = mis.t + mis.step_time;
    mis.V = mis.traj(2,n+1);
    mis.theta = mis.traj(3,n+1);
    mis.psi_c = mis.traj(4,n+1);
    mis.x = mis.traj(5,n+1);
    mis.y = mis.traj(6,n+1);
    mis.z = mis.traj(7,n+1);
    mis.traj(1,n+1) = mis.t;
    mis = mis.set_v();
end