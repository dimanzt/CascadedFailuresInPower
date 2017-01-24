%DIMAN ZAD TOOTAGHAJ
%PROBABILISTIC MODEL:

n=100;
m=100;
A=zeros(n,1);
B=zeros(m,1);
u=(rand(n+m,1)>0.8);

Tu= zeros(m+n,1);
Tu_no_coverage= zeros(m+n,1);
Attack_size= sum(u>0);

Attack_sizeA= sum(u(1:n,1)>0);
Attack_sizeB= sum(u(1+n:n+m,1)>0);

Dep=((rand(n+m)>0.95).*(ones(n+m)-eye(n+m)));
Dep_p= (rand(n+m)).*Dep;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time=10;
t=1:Time;
X=zeros(n+m,Time);
TX=X;
TX_no_coverage=X;

X(:,1)= u;
TX(:,1)= Tu;
TX_no_coverage(:,1)= Tu_no_coverage;
for i=2:Time
    X(:,i)= min(Dep_p* X(:,i-1) + X(:, i-1), ones(n+m,1));
    TX(:,i)= min(Dep_p* TX(:,i-1) + TX(:, i-1), ones(n+m,1));
    TX_no_coverage(:,i)= min(Dep_p* TX_no_coverage(:,i-1) + TX_no_coverage(:, i-1), ones(n+m,1));
end

X;

InitialA=sum(u(1:n,1));
InitialB=sum(u(n+1:n+m,1));

FailA=sum(X(1:n,:));
FailB=sum(X(n+1:n+m,:));

FailTA=sum(TX(1:n,:));
FailTB=sum(TX(n+1:n+m,:)); 

FailTA_no_cov=sum(TX_no_coverage(1:n,:));
FailTB_no_cov=sum(TX_no_coverage(n+1:n+m,:)); 

plot(t,FailA);
hold on;
plot(t,FailB);
hold on;
plot(t,FailTA);
hold on;
plot(t,FailTB);
% hold on;
% plot(FailTA_no_cov);
% hold on;
% plot(FailTB_no_cov);
legend('Random Failure A','Random Failure B', 'Traget Failre A', 'Target Failure B')
%, 'Traget Failre no coverage A', 'Target Failure no coverage B');



