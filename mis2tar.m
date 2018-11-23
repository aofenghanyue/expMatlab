function err = mis2tar(alpha_list, beta_list)
% �������Ŀ��������
% ���룺deg
% alpha_list: 1. �б�����ÿn�밴�б����ֵ�仯һ��
%                 (n������utils.point_to_fun���趨��Ĭ��Ϊ5)
%             2. ����ֵ������Ϊ��ֵ
% beta_list: �໬�ǣ��÷�ͬalpha_list
% ����������ν���ʱ��ƫ��

    % ����������Ŀ�����
    % x,y,z,vx,vy,vz
    targ = Particle(30000, 0, 0, 0, 0, 0);
    % x,y,z,V,theta,psi_c,alpha,beta
    mis = Missile(0, 4000, 0, 200, 0, 0, alpha_list, beta_list, targ);
    mis = mis.params_set();
    while true
        if mis.is_proj_fly(targ)
            % �ж��Ƿ񷽰�����
            mis = mis.step(targ, 0);
        elseif mis.is_guided(targ)
            % �ж��Ƿ�������
            mis = mis.step(targ, 1);
        else
            break;
        end
    end
%     result = mis.get_result();
%     mis.plot_traj(targ)
    err = mis.distance(targ);
end