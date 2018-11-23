%%  ���ַ����
%   matlab 2017b
function x_0 = bin_solve(fun,a,b,sup_acu,maxiter)
%   function [x_0, err] = bin_solve(fun,a,b,sup_acu,maxiter)
%	���ַ����
%   ���룺
%   fun��������ĺ���
%   a��b���������
%   sup_acu: max|x(k)-x(k-1)|
%   maxiter: ����������
%   �����x_0:���   err������/������
a = a-eps;
b = b+eps;
% ����a-eps,b+eps��Ϊ�˷�ֹ���ȡ�ڶ˵�ʱ����
fa = feval(fun,a);
fb = feval(fun,b);
if fa*fb>0
    error('��������������أ�����');
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

