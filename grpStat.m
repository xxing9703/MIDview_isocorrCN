%the input dataset is divided into groups based on grpName
%for each group, mean and std is calculated and stored in individual matric
function [ave,err]=grpStat(grpName, fullset)
ave=[];err=[];
[G,TD]=findgroups(grpName);
for i=1:length(TD)
    idx=find(G==i);
    subset=fullset(:,idx);
    for j=1:size(subset,1)
        ave(j,i)=mean(subset(j,:));
        err(j,i)=std(subset(j,:));
    end
end