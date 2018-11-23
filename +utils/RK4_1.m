%%  �����������������
%   matlab 2017b

function y_t2 = RK4_1(fun, t1, y_t1, h)
%   fun: �����ķ���
%   y_t1: ǰһʱ�̸�������ֵ
%   h: ��������ȡ��ֵ
%   ���t1+hʱ�̵Ĳ���ֵ
k1 = feval(fun,t1,y_t1);
k2 = feval(fun,t1+h/2,y_t1+h*k1/2);
k3 = feval(fun,t1+h/2,y_t1+h*k2/2);
k4 = feval(fun,t1+h,y_t1+h*k3);
y_t2 = y_t1+h/6*(k1+2*k2+2*k3+k4);