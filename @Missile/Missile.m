% 导弹
classdef Missile < Particle
    properties
        t = 0;
        theta = 0;
        psi_c = 0;
        alpha = 0;
        beta = 0;
        ft_alpha;	% 方案攻角
        ft_beta;	% 方案侧滑角
        traj;       % 弹道
    end
    properties
        % 自定义
        step_time = 0;
        guide_dis_max = 12000; % 最大导引距离
        guide_dis_min = 200;  % 最大导引距离
        K = 4;      % 导引段比例系数
        s;          % 参考面积
        CL_Ma_alpha;
        CD_Ma_alpha;
        Ma_point;
        alpha_point;
        alpha_max;  % 最大攻角
        beta_max;   % 最大侧滑角
        ft_push;	% 推力
        ft_m;       % 质量
    end
    methods
        function mis = Missile(x,y,z,V,theta,psi_c,alpha,beta,tar)
            % 初始化导弹
            % alpha、beta为list(单位：°)，输入分段函数的各段值
            import utils.point_to_fun
            mis = mis@Particle(x,y,z,0,0,0);
            mis.V = V;
            mis.psi_c = psi_c;
            mis.theta = theta;
            mis = mis.set_v();
            mis = mis.traj_init(tar);
            mis.ft_alpha = point_to_fun(degtorad(alpha));
            mis.ft_beta = point_to_fun(degtorad(beta));
        end
        function res = push(mis)
            % 获取当前推力
            res = mis.ft_push(mis.t);
        end
        function res = m(mis)
            % 获取当前质量
            res = mis.ft_m(mis.t);
        end
        function res = get_mach(mis)
            % 获取当前导弹马赫数
            v = mis.getv();
            res = mis.Mach(v, mis.y);
        end
        function res = C_inf(mis)
            % 获得当前来流总压
            res = 0.5*mis.rho(mis.y)*(mis.getv())^2*mis.s;
        end
        function res = get_Y(mis)
            % 获取当前升力
            res = mis.Y(mis.getv(), mis.y, mis.alpha);
        end
        function res = get_X(mis)
            res = mis.X(mis.getv(), mis.y, mis.alpha);
        end
        function res = get_result(mis)
            res = mis.traj(:,1:round(mis.t/mis.step_time+1));
        end
        
        function mis = set_v(mis)
            mis.vx = mis.V * cos(mis.theta) * cos(mis.psi_c);
            mis.vy = mis.V * sin(mis.theta);
            mis.vz = mis.V * cos(mis.theta) * sin(mis.psi_c);
        end
        function res = Mach(mis, V, h)
            % 通过速度、高度，求马赫数
            res = V/mis.c(h);
        end
        function res = Y(mis, V, h, alpha)
            % 给定攻角、速度、高度，求升力
            import utils.interp_2m
            Ma = mis.Mach(V, h);
            CL = sign(alpha)*interp_2m(mis.Ma_point, mis.alpha_point,...
                        mis.CL_Ma_alpha, Ma, abs(alpha));
            res = mis.C_inf * CL;
        end
        function res = X(mis, V, h, alpha)
            % 给定攻角、速度、高度，求阻力
            import utils.interp_2m
            Ma = mis.Mach(V, h);
            CD = interp_2m(mis.Ma_point, mis.alpha_point,...
                        mis.CD_Ma_alpha, Ma, abs(alpha));
            res = mis.C_inf * CD;
        end
        function res = is_proj_fly(mis,targ)
            res = (mis.distance(targ) > mis.guide_dis_max)...
                && (mis.y > 0);
        end
        function res = is_guided(mis, targ)
            res = (mis.distance(targ) > mis.guide_dis_min)...
                && (mis.y > 0);
        end
        function mis = traj_init(mis, tar)
            % 创建弹道参数存储矩阵
            % [t, V, theta, psi_c, x, y, z, beta, alpha, n_y, n_z]
            columns = round((tar.x-mis.x) / (mis.vx-tar.vx));
            mis.traj = zeros(11, columns);
            mis.traj(1:7,1) = [mis.t, mis.V, mis.theta,...
                            mis.psi_c, mis.x, mis.y, mis.z];
        end
        
    end

    methods
        % 设定导弹参数
        mis = params_set(mis)
        % 求实际过载
        [n_y, n_z] = overload(mis,target)
        % 求导引段攻角、侧滑角
        [alpha_gt, beta_gt, n_y, n_z] = angle_gt(mis, target)
        % 运动微分方程
        d_var = GTDE(mis, t, var)
        % 步进：计算下一步导弹状态
        mis = step(mis, tar, method)
        % 画出导弹弹道
        p = plot_traj(mis, tar)
    end
end