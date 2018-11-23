%%  二分法求根
%   matlab 2017b
function x_0 = bin_solve(fun,a,b,sup_acu,maxiter)
%   function [x_0, err] = bin_solve(fun,a,b,sup_acu,maxiter)
%	二分法求根
%   输入：
%   fun：待求根的函数
%   a，b：求根区间
%   sup_acu: max|x(k)-x(k-1)|
%   maxiter: 最大迭代次数
%   输出：x_0:零点   err：精度/误差估计
a = a-eps;
b = b+eps;
% 这里a-eps,b+eps是为了防止零点取在端点时报错
fa = feval(fun,a);
fb = feval(fun,b);
if fa*fb>0
    error('臣妾做不到啊￣へ￣！！');
end
if nargin<5
    maxiter  = 60;
end
if nargin<4
    sup_acu = 1e-5;
end
k = 0;
tt = b-a;
while (tt>=sup_acu) && (k<maxiter)
    c = (a+b)/2;
    fc = feval(fun,c);
    err = (b-a)/2;
    if abs(fc) < eps || abs(err)<sup_acu
        break;
    elseif fa * fc>0
        a = c;
        fa = fc;
    else
        b = c;
    end
    tt = err;
    k = k+1;
end
x_0 = c;

