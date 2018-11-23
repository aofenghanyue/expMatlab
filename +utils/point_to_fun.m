function k = point_to_fun(point_list)
    % 将离散点变为分段函数
    % 例如：fun = point_to_fun([1,2,3])
    %               1 (0<=t<5)
    % 则：fun(t) =  2 (5<=t<10)
    %               3 (10<=t<inf)
    
    function res = step_fun(t)
        res = step_const_fun(point_list, t);
    end
    k = @step_fun;
end

function f = step_const_fun(value, t)
    step_time = 5;
    if t < step_time*length(value)
        f = value(floor(t/step_time)+1);
    else
        f = value(end);
    end
end