function X = SI(mx,my)
%SIALGORITHM ����������ʵ�����߶�λ�е�SI�㷨
%7С����������
BSN=4;
CR=15;%��վλ��
BS=zeros(2,7);
BS(:,1)=[0,0];
BS(:,2)=[0,3*CR];
BS(:,3)=[3*CR,3*CR];
BS(:,4)=[3*CR,0];
MS = [mx;my];
%��ֵΪ0�ĸ�˹����
c=3*10^8;
Nmeasure=0.05*10^(-8);
Noise=c*Nmeasure*randn(1);
%����ʱ����չ
T=0.1;%������ʱ�ӳ̶�
%tmax=T*d^0.5*10^0.4*randn;
% Ri1
R1 = sqrt(MS(1)^2 + MS(2)^2);
for i = 1: BSN-1,
    R(i) = sqrt((BS(1, i+1) - MS(1))^2 + (BS(2, i+1) - MS(2))^2);
end
for i = 1: BSN-1,
    Ri1(i) = R(i) - R1 ;+ T*R(i)^0.5*10^0.4*randn + Noise;
end
    
% W
W = eye(BSN-1);

% delt
for i = 1: BSN-1,
    K(i) = BS(1, i+1)^2 + BS(2, i+1)^2;
end
for i = 1: BSN-1,
    delt(i) = K(i) - Ri1(i)^2;
end

% Pd orthognol
I = eye(BSN-1);
coef = Ri1*Ri1';
Pd_o = I - (Ri1'*Ri1/coef);
    
% S
for i = 1: BSN-1,
    S(i, 1) = BS(1, i+1);
    S(i, 2) = BS(2, i+1);
end

% �����
    Za = 0.5*inv(S'*Pd_o*W*Pd_o*S)*S'*Pd_o*W*Pd_o*delt';
    X = Za;
