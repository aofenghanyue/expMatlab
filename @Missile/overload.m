function [n_y, n_z] = overload(mis, tar)
% 求当前导弹到目标的实际过载
    [n_yn, n_zn] = overload_n(mis, tar);
    [n_ya, n_za] = overload_a(mis);
    n_y = min(abs(n_yn), abs(n_ya)) * sign(n_yn);
    n_z = min(abs(n_zn), abs(n_za)) * sign(n_zn);
end
    
function [n_yn, n_zn] = overload_n(mis, tar)
% 需用过载
    [q_yaw, q_pitch] = mis.angle_sight(tar);
    
    R = distance(mis, tar);
    % 相对运动 dR、dq_yaw、dq_yaw 
    dR = -mis.V*cos(mis.theta)*cos(q_pitch)*cos(mis.psi_c+q_yaw)+...
        (tar.vx*cos(q_pitch)*cos(q_yaw)+tar.vy*sin(q_pitch)+...
        tar.vz*cos(q_pitch)*sin(q_yaw));
    dq_yaw = 1/(R*cos(q_pitch))*(mis.V*cos(mis.theta)*sin(mis.psi_c+q_yaw)+...
        tar.vz*cos(q_yaw)-tar.vx*sin(q_yaw));
    dq_pitch = 1/R*(mis.V*(cos(mis.theta)*sin(q_pitch)*cos(mis.psi_c+q_yaw)-...
        sin(mis.theta)*cos(q_pitch))-tar.vx*sin(q_pitch)*cos(q_yaw)+...
        tar.vy*cos(q_pitch)-tar.vz*sin(q_pitch)*sin(q_yaw));

    % 指令加速度
    a_yc = -mis.K * dR * dq_pitch / cos(q_yaw-mis.theta);
    a_zc = -mis.K * dR * dq_yaw / cos(q_pitch-mis.psi_c) * cos(q_pitch);

    % 需用过载
    n_yn=a_yc/mis.g + cos(mis.theta);
    n_zn=a_zc/mis.g;
end

function [n_ya, n_za] = overload_a(mis)
% 可用过载
    n_ya = (mis.push()*sin(mis.alpha_max)...
        + mis.Y(mis.V,mis.y,mis.alpha_max)) / mis.m() / mis.g;
    n_za = (-mis.push()*cos(mis.alpha_max)*sin(mis.beta_max)...
        + mis.Y(mis.V,mis.y,mis.beta_max)) / mis.m() / mis.g;
end