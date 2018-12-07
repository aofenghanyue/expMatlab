function [mis, targ, err] = mis2tar(alpha_list, beta_list)
% 导弹打击目标主程�?
% 输入：deg
% alpha_list: 1. 列表，攻角每n秒按列表里的值变化一�?
%                 (n可以在utils.point_to_fun里设定，默认�?5)
%             2. 单个值，攻角为定�?
% beta_list: 侧滑角，用法同alpha_list
% 输出：导引段结束时的偏差

    % 建立导弹、目标对�?
    % x,y,z,vx,vy,vz
    targ = Particle(30000, 0, 0, 0, 0, 0);
    % x,y,z,V,theta,psi_c,alpha,beta
    mis = Missile(0, 4000, 0, 200, 0, 0, alpha_list, beta_list, targ);
    mis = mis.params_set();
    while true
        if mis.is_proj_fly(targ)
            % 判断是否方案弹道
            mis = mis.step(targ, 0);
        elseif mis.is_guided(targ)
            % 判断是否导引弹道
            mis = mis.step(targ, 1);
		elseif mis.y > 0
			% 判断是否落地
			mis = mis.step(targ, 2);
        else
            break;
        end
    end
%     result = mis.get_result();
%     mis.plot_traj(targ)
    err = mis.distance(targ);
end