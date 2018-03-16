function p=t2p(t,df)

% one-tailed p-value

p=spm_Tcdf(t,df);
f=find(p>0.5);
p(f)=1-p(f);
