function mis = params_set(mis)
    % 设定导弹参数
    
    % 升力系数插值样点
    mis.CL_Ma_alpha = [	0         0         0         0;
                        0    0.3026    0.2177    0.2059;
                        0    0.5563    0.4575    0.4125;
                        0    0.8370    0.7115    0.6500;
                        0    1.1525    0.9908    0.9101;
                        0    1.4881    1.2963    1.1929;
                        0    1.8385    1.6092    1.4976;
                        0    2.2253    1.9565    1.8202;
                        0    2.6441    2.3274    2.1578;
                        0    3.0707    2.7178    2.5276;
                        0    3.5015    3.1426    2.9163;
                        0    3.9479    3.6243    3.3030;
                        0    4.4047    4.1390    3.7001;
                        0    4.8619    4.6591    4.1197;
                        0    5.3211    5.1788    4.5346;
                        0    5.7864    5.7082    4.9241];
	% 阻力系数插值样点
    mis.CD_Ma_alpha = [	0    1.1497    0.8709    0.8205;
                        0    1.1715    0.8874    0.8280;
                        0    1.1976    0.9111    0.8496;
                        0    1.2333    0.9441    0.8790;
                        0    1.2819    0.9846    0.9204;
                        0    1.3413    1.0338    0.9690;
                        0    1.4172    1.0929    1.0320;
                        0    1.5090    1.1691    1.1007;
                        0    1.6137    1.2591    1.1769;
                        0    1.7643    1.3857    1.2675;
                        0    1.9347    1.5183    1.3806;
                        0    2.1210    1.6671    1.5141;
                        0    2.3217    1.8327    1.6599;
                        0    2.5359    2.0187    1.8249;
                        0    2.7621    2.2230    2.0064;
                        0    2.9994    2.4480    2.1918];
    % 马赫数取样点
    mis.Ma_point = [0,1.2,2,3];
    % 攻角取样点
    mis.alpha_point = 0:1:15;
    
    % 推力模型
    % 推力T是时间t的函数
    Tmax = 4.5e4;   % 最大推力 N
    cc = 0.2;        % 常系数
    mis.ft_push = @(t)(Tmax*(0<=t&&t<3)+cc*Tmax*(t>=3&&t<18));
    
    % 质量模型
    m0 = 350; %	初始质量 kg
    mf = 119; %	最终质量 kg
    Isp = 230;
    mis.ft_m = @(t)(m0 - t*mis.ft_push(t)/mis.g/Isp)*(0<=t&&t<3)...
        + (m0 - 3*Tmax/mis.g/Isp - (t-3)*mis.ft_push(t)/mis.g/Isp)...
        * (t>=3&&t<18) + mf*(t>=18);
    
    % 参考面积
    mis.s = 0.05;
    
    % 导引段比例系数
    mis.K = 4;
    
    % 最大攻角、侧滑角 rad
    mis.alpha_max = pi/6;
    mis.beta_max = pi/6;
    
    % 最大导引距离 m
    mis.guide_dis_max = 12000;
    % 最小导引距离 m
    mis.guide_dis_min = 200;
    
    % 积分步长
    mis.step_time = 0.1;

end