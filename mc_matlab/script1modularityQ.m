clear;clc;load DB
N=16;
E=N*(N-1)/2;
CN = nchoosek(1:N,2); % for all the combinations of links (2regions)
CE = nchoosek(1:E,2); % for all the combinations of links (4regions interacgtion meta corr)
Nmin1=1;Nmax1=6;
CNnew = nchoosek(Nmin1:Nmax1,2); % 
Nmin2=7;Nmax2=16;
CNnew(76:120,:) = nchoosek(Nmin2:Nmax2,2);
k=15;
for i=Nmin1:Nmax1
    for j=Nmin2:Nmax2
        k=k+1;
        CNnew(k,1)=i;
        CNnew(k,2)=j;
    end
end
clear Nmin1 Nmin2 Nmax1 Nmax2

x=CNnew;clear CNnew; % x is the 120 links combinations
CNnew(1:60,:)=x(16:75,:); % combination between cingulate and other regions
CNnew(61:75,:)=x(1:15,:); % combination between cingulate
CNnew(76:120,:)=x(76:120,:); % combination between other regions




% 2.2.2 sort DC
for e=1:E
    idx(e,1)=find(CN(:,1)==CNnew(e,1) & CN(:,2)==CNnew(e,2)); %CN: original order; CNnew: sorted order
end

for cat=1:73
    A=zeros(E);
%     B=group(cat).MC;
    B=subject(cat).MC;
    for e=1:E-1
        for f=e+1:E
            A(e,f)=B(idx(e),idx(f));
        end
    end
    A=A+A';
    Z(cat).DCs=A;
end


% a(1)=0;a(2)=15;a(3)=35;a(4)=55;a(5)=75;a(6)=120;

a(1)=0;a(2)=20;a(3)=40;a(4)=60;a(5)=75;a(6)=120;

% first 20: aCNG-L and aCNG-R with other regions
% second 20: mCNG-L and mCNG-R with other regions
% third 20: pCNG-L and pCNG-R with other regions
% fourth: cingulate regions inside
% fifth: other regions inside 

for e=1:length(a)-1
    ModulesDC(a(e)+1:a(e+1))=e;
end
[x1,y1,indsort1]=grid_communities(ModulesDC);


%% index of modularity
M2=repmat(ModulesDC,73,1);
g=0;
for gamma=.1:.1:2
    g=g+1;
for cat=1:73
    W=Z(cat).DCs;
    [M(:,cat),Q(cat)]=community_louvain(W,gamma,ModulesDC,'negative_asym');
end

var=corrcoef(M,M2');
cc(g,1)=var(2);
cc(g,2)=gamma;
p1(g) = anovan(Q,label,'display','off');
p2(g) = kruskalwallis(Q,label,'off');
end
plot(cc)


for cat=1:73
    W=Z(cat).DCs;
    [M(:,cat),Q(cat)]=community_louvain(W,1.1,ModulesDC,'negative_asym');
end

subplot(1,2,1);imagesc(M);subplot(1,2,2);boxplot(Q,label)


    


