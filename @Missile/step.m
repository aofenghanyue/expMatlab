function mis = step(mis, tar, method)
% 根据method来积分，以获得下一步导弹的状态
% method = 0 : 方案弹道积分
% method = 1 : 导引弹道积分

    n = round(mis.t/mis.step_time) + 1;
    if method == 0
        mis = step_project(mis, n);
    elseif method == 1
        mis = step_guide(mis, tar, n);
	elseif method == 2
		mis = step_inert(mis, n);
    end
end

function mis = step_project(mis, n)
% 方案弹道
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
% 导引弹道
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

function mis = step_inert(mis, n)
% 惯性飞行
	mis.alpha = mis.traj(8,n-1);
    mis.beta = mis.traj(9,n-1);
	mis.traj(8,n) = mis.alpha;
    mis.traj(9,n) = mis.beta;
	var = [mis.V, mis.theta, mis.psi_c, mis.x, mis.y, mis.z];
	
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
