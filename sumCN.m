%out is the full table of C/N labeled intensities
%Conly Nonly sums up along each dimension.
function [Conly, Nonly,total]=sumCN(out,Cnum,Nnum)
  for i=1:Cnum+1
     Conly(i,:)=sum(out((i-1)*(Nnum+1)+1:i*(Nnum+1),:),1);
  end
  for i=1:Nnum+1
     Nonly(i,:)=sum(out(i:Nnum+1:(Nnum+1)*Cnum+i,:),1);
  end
 total=sum(out,1);
      