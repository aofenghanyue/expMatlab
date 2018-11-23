%%  二维插值
%   matlab 2017b

function line_2 = interp_2m(x, y, fxy, x0,y0)
%   x，y: 两个维度的取样点
%   fxy：样点处的值
%   x0,y0： 需要插值的点

% 线性插值
% x坐标插值，输出x0处的f(x0,y)数组
f_x0_y = interp_1m(x,fxy,x0);
% y坐标插值，得出结果
line_2 = interp_1m(y,f_x0_y',y0);

% 方法二：
% line_2 = interp2(x,y,fxy,x0,y0);


%%  一维插值
function line_1 = interp_1m(x, fx, x0)
% x: 样本点，为从小到大排列的数组
% fx: 样本点处的值，为与x相同维度的数组
% x0: 需要插值的点

% 线性插值
% 求出与x0相邻的两个点
x_left = x(x <= x0); % 比x0小的点
x_right = x(x >= x0); % 比x0大的点

% 外点
if x0>=x(end)
    x_left = x(end-1);
    x_right = x(end);
elseif x0<=x(1)
    x_left = x(1);
    x_right = x(2);
end

% 相邻点
% 调试
try
    x1 = x_left(end);
    x2 = x_right(1);
catch err
    throw(err)
end

y1 = fx(:,x==x1);
y2 = fx(:,x==x2);

% 线性组合
line_1 = y1+(y2-y1+eps)./(x2-x1+eps).*(x0-x1);
% 这里用.* ./是为了兼容多维数组操作
% +eps为了防止插值点与已知点重合出现bug

% 方法二：
% 使用interp1函数
% line_1 = interp1(x , fx , x0);
% 变量意义同上