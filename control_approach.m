%Diman Code for interdependent networks:

%A=zeros(1,n);
%B=zeros(1,m);

%fail_A= 0.1*n;
%fail_B = 0.1*m;

%transient_A= ;
%transient_B= ;
% x(k+1) = A x(k) + x(k)+ u(k)
n=100;
m=100;
%Dep=[0 0 1; 1 0 1; 1 0 0];
A=zeros(n,1);
B=zeros(m,1);
% Random Attack
u=(rand(n+m,1)>0.8);
%u = zeros(n+m,1);
%u(1,1) =1;
%u(5,1) =1;
Tu= zeros(m+n,1);
Tu_no_coverage= zeros(m+n,1);
Attack_size= sum(u>0);

Attack_sizeA= sum(u(1:n,1)>0);
Attack_sizeB= sum(u(1+n:n+m,1)>0);

Dep=((rand(n+m)>0.995).*(ones(n+m)-eye(n+m)));
%Dep=[0 0 0 0 0 0 0; 1 0 0 0 0 0 0; 0 1 0 0 0 0 0; 0 0 1 0 0 0 0; 1 0 0 0 0 0 0; 0 0 0 0 1 0 0; 0 0 0 0 1 0 0];
% Targeted attacks Max Coverage:
%syms z;
z= 50;
T=(z*eye(n+m)- Dep - eye(n+m))^-1;
Indicator= T>0;
Impact=0;
for j=1:Attack_sizeA
    for i=1: n
        Temp=sum(Indicator(:,i));
        if (Temp > Impact)
            Impact = Temp;            
            selected= i;
        end
    end
    Tu(selected, 1) =1;
    %%%%%%%%%%%%%%%%%%%%%%%%%
    for k=1:n
        T(:, k) =T(:,k).* (ones(n+m,1)- T(:, selected));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    T(:, selected)=zeros(n+m,1);
    Indicator= T>0;
    %Indicator(:,selected)=zeros(n+m,1);
    Impact=0;
end
Impact=0;
for j=1:Attack_sizeB
    for i=n+1: n+m
        Temp=sum(Indicator(:,i));
        if (Temp > Impact)
            Impact = Temp;            
            selected= i;
        end
    end
    Tu(selected, 1) =1;
    %%%%%%%%%%%%%%%%%%%%%%%%%
    for k=n+1:n+m
        T(:, k) =T(:,k).* (ones(n+m,1)- T(:, selected));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    T(:, selected)=zeros(n+m,1);    
    Indicator= T>0;
    %Indicator(:,selected)=zeros(n+m,1);
    Impact=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Target Attack Not max coverage
% Targeted attacks Max Coverage:
%syms z;
z= 50;
T=(z*eye(n+m)- Dep - eye(n+m))^-1;
Indicator= T>0;
Impact=0;
for j=1:Attack_sizeA
    for i=1: n
        Temp=sum(Indicator(:,i));
        if (Temp > Impact)
            Impact = Temp;            
            selected= i;
        end
    end
    Tu_no_coverage(selected, 1) =1;
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %for k=1:n
    %    T(:, k) =T(:,k).* (ones(n+m,1)- T(:, selected));
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    T(:, selected)=zeros(n+m,1);
    Indicator= T>0;
    %Indicator(:,selected)=zeros(n+m,1);
    Impact=0;
end
Impact=0;
for j=1:Attack_sizeB
    for i=n+1: n+m
        Temp=sum(Indicator(:,i));
        if (Temp > Impact)
            Impact = Temp;            
            selected= i;
        end
    end
    Tu_no_coverage(selected, 1) =1;
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %for k=n+1:n+m
    %    T(:, k) =T(:,k).* (ones(n+m,1)- T(:, selected));
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    T(:, selected)=zeros(n+m,1);    
    Indicator= T>0;
    %Indicator(:,selected)=zeros(n+m,1);
    Impact=0;
end
Time=10;
t=1:Time;
X=zeros(n+m,Time);
TX=X;
TX_no_coverage=X;

X(:,1)= u;
TX(:,1)= Tu;
TX_no_coverage= Tu_no_coverage;
for i=2:Time
    X(:,i)= min(Dep* X(:,i-1) + X(:, i-1), ones(n+m,1));
    TX(:,i)= min(Dep* TX(:,i-1) + TX(:, i-1), ones(n+m,1));
    TX_no_coverage(:,i)= min(Dep* TX_no_coverage(:,i-1) + TX_no_coverage(:, i-1), ones(n+m,1));
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




%###########################################################################
%###########################################################################
%###########################################################################
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write a mitigation effort
%How? 1) Cut the dependency 2) Run the Recovery by finding smallest set of
%independent nodes first and 
Recovery_Time= 2;
Leaf= min(Dep* X(:,Recovery_Time ) + X(:, Recovery_Time), ones(n+m,1)) - X(:, Recovery_Time);

X=zeros(n+m,Time);
TX=X;

X(:,1)= u;
TX(:,1)= Tu;
TX_no_coverage= Tu_no_coverage;
for i=2:Recovery_Time
    X(:,i)= min(Dep* X(:,i-1) + X(:, i-1), ones(n+m,1));
    TX(:,i)= min(Dep* TX(:,i-1) + TX(:, i-1), ones(n+m,1));
end

z= 50;
T=(z*eye(n+m)- Dep - eye(n+m))^-1;
Indicator= (T>0);
Indicator2=Indicator.*(ones(n+m,n+m)-eye(n+m,n+m));
Impact=0;
Recovered_nodes=zeros(n+m,Time);
Current_Time =Recovery_Time;
Recovery_Resources= Attack_size;
for j=Recovery_Time:Time-1
    for i=1: n+m
        Temp=sum(Indicator2(:,i).* TX(:,Current_Time));
        if (Temp > Impact) && (TX(i,Current_Time)==1)
            Impact = Temp;            
            selected= i;
        end
    end
    selected
    Recovered_nodes(:, Current_Time)=   Indicator2(:,selected).* TX(:,Current_Time);
    for f=1: m+ n
        if f ~=selected
            Recovered_nodes(:, Current_Time)=  max(zeros(m+n,1),(Recovered_nodes(:, Current_Time) - (Tu(f,1))*Indicator(:,f)).* TX(:,Current_Time));
        end
    end
    %Recovered_nodes(:, Current_Time) =Indicator(:,selected);
    Recovered_nodes(selected, Current_Time) =1;
    Recovered_nodes(:, Current_Time)
    Current_Time= Current_Time+1;
    TX(:,Current_Time)= max(zeros(m+n,1),TX(:,Current_Time-1) - Recovered_nodes(:, Current_Time-1));
    %Recovered_nodes=zeros(n+m,Time);

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %for k=1:n+m
    %    T(:, k) =T(:,k).* (ones(n+m,1)- T(:, selected));
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    T(:, selected)=zeros(n+m,1);
    Indicator= T>0;
    %Indicator(:,selected)=zeros(n+m,1);
    Impact=0;
end

% RecoveryA=sum(TX(1:n,:));
% RecoveryB=sum(TX(n+1:n+m,:)); 
% hold on;
% plot(t,RecoveryA);
% hold on;
% plot(t,RecoveryB);

% hold on;
% plot(FailTA_no_cov);
% hold on;
% plot(FailTB_no_cov);
%legend('Random Failure A','Random Failure B', 'Traget Failre A', 'Target Failure B', 'Recovery A', 'Recovery B')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%###################################################################
Recovery_Time= 3;
Leaf= min(Dep* X(:,Recovery_Time ) + X(:, Recovery_Time), ones(n+m,1)) - X(:, Recovery_Time);

X=zeros(n+m,Time);
TX=X;

X(:,1)= u;
TX(:,1)= Tu;
TX_no_coverage= Tu_no_coverage;
for i=2:Recovery_Time
    X(:,i)= min(Dep* X(:,i-1) + X(:, i-1), ones(n+m,1));
    TX(:,i)= min(Dep* TX(:,i-1) + TX(:, i-1), ones(n+m,1));
end

z= 50;
T=(z*eye(n+m)- Dep - eye(n+m))^-1;
Indicator= (T>0);
Indicator2=Indicator.*(ones(n+m,n+m)-eye(n+m,n+m));
Impact=0;
Recovered_nodes=zeros(n+m,Time);
Current_Time =Recovery_Time;
Recovery_Resources= Attack_size;
for j=Recovery_Time:Time-1
    for i=1: n+m
        Temp=sum(Indicator2(:,i).* TX(:,Current_Time));
        if (Temp > Impact) && (TX(i,Current_Time)==1)
            Impact = Temp;            
            selected= i;
        end
    end
    selected
    Recovered_nodes(:, Current_Time)=   Indicator2(:,selected).* TX(:,Current_Time);
    for f=1: m+ n
        if f ~=selected
            Recovered_nodes(:, Current_Time)=  max(zeros(m+n,1),(Recovered_nodes(:, Current_Time) - (Tu(f,1))*Indicator(:,f)).* TX(:,Current_Time));
        end
    end
    %Recovered_nodes(:, Current_Time) =Indicator(:,selected);
    Recovered_nodes(selected, Current_Time) =1;
    Recovered_nodes(:, Current_Time)
    Current_Time= Current_Time+1;
    TX(:,Current_Time)= max(zeros(m+n,1),TX(:,Current_Time-1) - Recovered_nodes(:, Current_Time-1));
    %Recovered_nodes=zeros(n+m,Time);

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %for k=1:n+m
    %    T(:, k) =T(:,k).* (ones(n+m,1)- T(:, selected));
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    T(:, selected)=zeros(n+m,1);
    Indicator= T>0;
    %Indicator(:,selected)=zeros(n+m,1);
    Impact=0;
end

% RecoveryA=sum(TX(1:n,:));
% RecoveryB=sum(TX(n+1:n+m,:)); 
% hold on;
% plot(t,RecoveryA);
% hold on;
% plot(t,RecoveryB);


%%legend('Random Failure A','Random Failure B', 'Traget Failre A', 'Target Failure B', 'Recovery A at 2', 'Recovery B at 2', 'Recovery A at 3', 'Recovery B at 3')

%#######################################################







%Laplacian transform:
%X'  = AX+ X+U -> (SI- A )X = U
syms s t;
%Finding average dependency: if u(i,1) fails how much A and B will fail?
%get an average over all u(i,1)
DepAA=0;
DepAB=0;
DepBA=0;
DepBB=0;
for i=1:n
    uA=zeros(m+n,1);
    uA(i,1) =1;
    x=min(Dep*uA, ones(m+n,1));
    DepAA= DepAA+ sum(x(1:n,1));
    DepAB= DepAB+ sum(x(n+1:n+m,1));
end
DepAA= DepAA./(n);
DepAB= DepAB./(m);
for i=n+1:n+m
    uB=zeros(m+n,1);
    uB(i,1) =1;
    y=min(Dep*uB, ones(m+n,1));
    DepBB= DepBB+ sum(y(n+1:n+m,1));
    DepBA= DepBA+ sum(y(1:n,1));
end
DepBB= DepBB./(m);
DepBA =DepBA./(n);

    

% uA=[ones(n,1); zeros(m,1)];
% x=min(Dep*uA, ones(m+n,1));
% DepAA= sum(x(1:n,1))./n;
% DepAB = sum(x(n+1:n+m,1))./m;
% uB=[zeros(n,1); ones(m,1)];
% y=min(Dep*uB, ones(m+n,1));
% DepBB= sum(y(n+1:n+m,1))./m;
% DepBA = sum(y(1:n,1))./n;

Dep2=[DepAA, DepBA; DepAB, DepBB];
Dep2;
u2= [InitialA./n; InitialB./m];
F= (s*eye(2)- Dep2)^(-1)*u2;
f = ilaplace(F, s, t)

%t2=0:0.6/4:0.6;

