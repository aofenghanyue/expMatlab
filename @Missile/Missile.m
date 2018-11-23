% ����
classdef Missile < Particle
    properties
        t = 0;
        theta = 0;
        psi_c = 0;
        alpha = 0;
        beta = 0;
        ft_alpha;	% ��������
        ft_beta;	% �����໬��
        traj;       % ����
    end
    properties
        % �Զ���
        step_time = 0;
        guide_dis_max = 12000; % ���������
        guide_dis_min = 200;  % ���������
        K = 4;      % �����α���ϵ��
        s;          % �ο����
        CL_Ma_alpha;
        CD_Ma_alpha;
        Ma_point;
        alpha_point;
        alpha_max;  % ��󹥽�
        beta_max;   % ���໬��
        ft_push;	% ����
        ft_m;       % ����
    end
    methods
        function mis = Missile(x,y,z,V,theta,psi_c,alpha,beta,tar)
            % ��ʼ������
            % alpha��betaΪlist(��λ����)������ֶκ����ĸ���ֵ
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
            % ��ȡ��ǰ����
            res = mis.ft_push(mis.t);
        end
        function res = m(mis)
            % ��ȡ��ǰ����
            res = mis.ft_m(mis.t);
        end
        function res = get_mach(mis)
            % ��ȡ��ǰ���������
            v = mis.getv();
            res = mis.Mach(v, mis.y);
        end
        function res = C_inf(mis)
            % ��õ�ǰ������ѹ
            res = 0.5*mis.rho(mis.y)*(mis.getv())^2*mis.s;
        end
        function res = get_Y(mis)
            % ��ȡ��ǰ����
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
            % ͨ���ٶȡ��߶ȣ��������
            res = V/mis.c(h);
        end
        function res = Y(mis, V, h, alpha)
            % �������ǡ��ٶȡ��߶ȣ�������
            import utils.interp_2m
            Ma = mis.Mach(V, h);
            CL = sign(alpha)*interp_2m(mis.Ma_point, mis.alpha_point,...
                        mis.CL_Ma_alpha, Ma, abs(alpha));
            res = mis.C_inf * CL;
        end
        function res = X(mis, V, h, alpha)
            % �������ǡ��ٶȡ��߶ȣ�������
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
            % �������������洢����
            % [t, V, theta, psi_c, x, y, z, beta, alpha, n_y, n_z]
            columns = round((tar.x-mis.x) / (mis.vx-tar.vx));
            mis.traj = zeros(11, columns);
            mis.traj(1:7,1) = [mis.t, mis.V, mis.theta,...
                            mis.psi_c, mis.x, mis.y, mis.z];
        end
        
    end

    methods
        % �趨��������
        mis = params_set(mis)
        % ��ʵ�ʹ���
        [n_y, n_z] = overload(mis,target)
        % �����ι��ǡ��໬��
        [alpha_gt, beta_gt, n_y, n_z] = angle_gt(mis, target)
        % �˶�΢�ַ���
        d_var = GTDE(mis, t, var)
        % ������������һ������״̬
        mis = step(mis, tar, method)
        % ������������
        p = plot_traj(mis, tar)
    end
end