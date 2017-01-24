%Diman Zad Tootaghaj
% DC-Power flow distribution model:
% SOURCE   : 
% 
%      Vittorio Rosato Ph.D.
%      Senior Research Scientist
%      ENEA (Italian National Agency for New Technologies,
%      Energy and the Environment)
%      Computing and Modelling Unit (CAMO)
%      Casaccia Research Center- Post Bag 111
%      Via Anguillarese 301 - 00060 S.M. di Galeria (Roma)
%      phone: +39.06.3048.4825
%      fax: +39.06.3048.6511 
% 
%  DATE     : May 2006
% 
%  COMMENTS : The network contains N=310 nodes 
%                 
% 	   Nodes from 1  to 113 are sources (power is inserted), 
%            nodes from 114 to 210 are loads (power is extracted) 
%            nodes from 211 to 310 are junctions (power just flows by).
%            The network has 347 single lines and 14 double lines 
%            (therefore 14 couples i-j are repeated in the attached file).


[names, power] = textread('power.txt','%d %f');

P_G= power(1:113,:);
P_L=power(114:210,:);
P=zeros(310,1);
P(1:113,1)=P_G;
P(114:210,1)=P_L;
%P= power;

F=power(211:310,:);

N=310;
X=zeros(N,N);
[link, from, to, reac] = textread('reactances.txt','%d %d %d %f');
N_links=length(link);

for l = 1:length(link)
    i=from(l);
    j=to(l);
    if (X(i,j)~=0)
        X(i,j)=reac(l)*X(i,j)./(X(i,j)+reac(l));
        X(j,i) = reac(l)*X(j,i)./(X(j,i)+reac(l));
    else
        X(i,j) = reac(l);
        X(j,i) = reac(l);
    end
end

Reactance=zeros(N,N);
for i= 1:N
    for j=1:N
        if (i ==j)
            for k=1:N
                if X(i,k) ~= 0
                    Reactance(i,j)= Reactance(i,j)+(1./X(i,k));
                end
            end
        else
            if X(i,j) ~= 0
                Reactance(i,j)= -1./X(i,j);
            end
        end
    end
end

F=zeros(N,1);
%F= Reactance*P;
F = Reactance*power
F_Max=ones(N,1);
%F_Max= max(F).*ones(N,1);
F_Max= 1.5.*F;
%%%%%%%%%%%%%Attack Model: Suppose that one of the transmission lines fail:
%X_Attack=X;
%attack_size= 1;
a=0;
my_AS=300;
failed=zeros(my_AS,1)
for as=1:20:my_AS
    a=0;
    X_Attack=X;
    attack_size = as;
    while a < attack_size
        i= randi([1 length(X)],1,1);
        j= randi([1 length(X)],1,1);
        if X(i,j) ~=0
            X_Attack(i,j)=0;
            a=a+1;
        end
    end

    Reactance_attack=zeros(N,N);
    for i= 1:N
        for j=1:N
            if (i ==j)
                for k=1:N
                    if X_Attack(i,k) ~= 0
                        Reactance_attack(i,j)= Reactance_attack(i,j)+(1./X_Attack(i,k));
                    end
                end
            else
                if X_Attack(i,j) ~= 0
                    Reactance_attack(i,j)= -1./X_Attack(i,j);
                end
            end
        end
    end

    F_Attack=zeros(N,1);
    %F= Reactance*P;
    F_Attack = Reactance_attack*power;

    failed(as,1) = sum(((F_Max- F_Attack) <0))
end
failed


