% 质点类
classdef Particle
    properties
        x = 0;
        y = 0;
        z = 0;
        vx = 0;
        vy = 0;
        vz = 0;
        V = 0;
    end
    
    properties (Constant)
        % 环境参数
        g = 9.8;
        % 大气密度
        rho = @(h)(1.225*exp(-0.00015*h));
        % 当地声速 c=sqrt(gamma*R*T)(h<11000m)
        c = @(h)(sqrt(1.4*286.85*(288.15-0.0065*h)));
    end
    
    methods
        % 方法
        function particle = Particle(x,y,z,vx,vy,vz)
            % 初始化质点对象，指定质点位置、速度
            if nargin == 6
                particle.x = x;
                particle.y = y;
                particle.z = z;
                particle.vx = vx;
                particle.vy = vy;
                particle.vz = vz;
            end
        end
        
        function v = getv(particle)
            % 得到当前质点的速度
            v = sqrt(particle.vx^2 + particle.vy^2 + particle.vz^2);
        end
            
        function r = distance(part1, part2)
            % 当前质点与质点part2的距离
            r = sqrt((part1.x-part2.x)^2 + (part1.y-part2.y)^2 ...
                + (part1.z-part2.z)^2);
        end
        
        function [q_yaw, q_pitch] = angle_sight(part1, part2)
            % part1相对于part2的视线角
            q_yaw = atan((part1.z-part2.z)/(part1.x-part2.x));
            q_pitch = asin((part2.y-part1.y)/distance(part1,part2));
        end
        
    end
end