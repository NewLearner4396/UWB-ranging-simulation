function main 
clc;
clear;  
T=1;%ɨ������
N=120/T;%��������  
CR=15;%��վλ��
BS=zeros(2,7);
BS(:,1)=[0,0];
BS(:,2)=[0,3*CR];
BS(:,3)=[3*CR,3*CR];
BS(:,4)=[3*CR,0];
X=zeros(4,N);%Ŀ����ʵλ�á��ٶ� 
X(:,1)=[30,2,40,2];%Ŀ���ʼλ��(30,40)�ٶ�(2,2)
Z=zeros(2,N);%��վ��λ�õĹ۲� 
a=exprnd(1,1,4);%ָ���ֲ��Ĺ�������
Q=diag(a);%��������
b=exprnd(3,1,2);
R=60*diag(b); %�۲�����ָ���ֲ�
A=[1,T,0,0;
   0,1,0,0;
   0,0,1,T;
   0,0,0,1]; %״̬ת�ƾ��� 
G=[1,0,0,0;
   0,0,1,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
for t=2:N      
    X(:,t)=A*X(:,t-1)+sqrtm(Q)*randn(4,1);%Ŀ����ʵ�켣     
end
MX=X(1,:);
MY=X(3,:);
for t=1:N
    yuce=SI(MX(1,t),MY(1,t));
    Z(:,t)=[yuce(1);yuce(2)]+sqrtm(R)*randn(2,1);%��Ŀ��Ĺ۲�
end

%Taylor����
for t=1:N
    track=Taylor(Z(1,t),Z(2,t));
    TL(:,t)=[track(1);track(2)]+sqrtm(R)*randn(2,1);%��Ŀ��Ĺ۲�
end

% Kalman�˲� 
Xkf=zeros(4,N); %�˲�������Ź��� 
Xkf(:,1)=X(:,1);%��ʼ�� 
P0=eye(4);% ���Э�������ʼ�� 
for i=2:N      
    %Ԥ�ⷽ��
    Xn=A*Xkf(:,i-1);%״̬Ԥ��     
    P1=A*P0*A'+Q;%Ԥ�����Э����  
    %��Ϣ����
    K=P1*G'/(G*P1*G'+R);%Kalman����
    %���Ʒ���
    Xkf(:,i)=Xn+K*(TL(:,i)-G*Xn);%״̬����     
    P0=(eye(4)-K*G)*P1;%�˲����Э������� 
end
% ������ 
for i=1:N      
    Observation(i)=RMS(X(:,i),Z(:,i));%�˲�ǰ�����  
    TaylorFilter(i)=RMS(X(:,i),TL(:,i));%Taylor����������
    KalmanFilter(i)=RMS(X(:,i),Xkf(:,i));%�������˲������� 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% ��ͼ 
figure 
hold on;box on;  
plot(BS(1,:),BS(2,:),'ko');%��վ
plot(X(1,:),X(3,:),'-k');%��ʵ�켣 
plot(Z(1,:),Z(2,:),'-mx');%�۲�켣  
plot(TL(1,:),TL(2,:),'-b');%Taylor�����켣
plot(Xkf(1,:),Xkf(3,:),'-r');%Kalman�˲��켣 
legend('��վλ��','��ʵ�켣','�۲�켣','Taylor�����켣','�������˲���켣') ;
xlabel('������ X/m'); ylabel('������ Y/m'); 
title('�켣ͼ');
figure 
hold on;box on;  
plot(Observation,'-ko','MarkerFace','m');
plot(TaylorFilter,'-kv','MarkerFace','b');
plot(KalmanFilter,'-ks','MarkerFace','r');
legend('�˲�ǰ���','Taylor���������','�������˲������');
xlabel('�۲�ʱ��/s'); ylabel('���ֵ'); 
title("�������Ա�");