%%  ��ά��ֵ
%   matlab 2017b

function line_2 = interp_2m(x, y, fxy, x0,y0)
%   x��y: ����ά�ȵ�ȡ����
%   fxy�����㴦��ֵ
%   x0,y0�� ��Ҫ��ֵ�ĵ�

% ���Բ�ֵ
% x�����ֵ�����x0����f(x0,y)����
f_x0_y = interp_1m(x,fxy,x0);
% y�����ֵ���ó����
line_2 = interp_1m(y,f_x0_y',y0);

% ��������
% line_2 = interp2(x,y,fxy,x0,y0);


%%  һά��ֵ
function line_1 = interp_1m(x, fx, x0)
% x: �����㣬Ϊ��С�������е�����
% fx: �����㴦��ֵ��Ϊ��x��ͬά�ȵ�����
% x0: ��Ҫ��ֵ�ĵ�

% ���Բ�ֵ
% �����x0���ڵ�������
x_left = x(x <= x0); % ��x0С�ĵ�
x_right = x(x >= x0); % ��x0��ĵ�

% ���
if x0>=x(end)
    x_left = x(end-1);
    x_right = x(end);
elseif x0<=x(1)
    x_left = x(1);
    x_right = x(2);
end

% ���ڵ�
% ����
try
    x1 = x_left(end);
    x2 = x_right(1);
catch err
    throw(err)
end

y1 = fx(:,x==x1);
y2 = fx(:,x==x2);

% �������
line_1 = y1+(y2-y1+eps)./(x2-x1+eps).*(x0-x1);
% ������.* ./��Ϊ�˼��ݶ�ά�������
% +epsΪ�˷�ֹ��ֵ������֪���غϳ���bug

% ��������
% ʹ��interp1����
% line_1 = interp1(x , fx , x0);
% ��������ͬ��