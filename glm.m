function [t,F,p,R2,B] = glm(X,y,c,pflag);

% Rik Henson, 2004
% c should be a column vector!

if nargin<4
	pflag=0;
end

B = pinv(X)*y;

Y = X*B;

r = y - Y;

if size(c,2) > size(c,1)
     warning('Transposing c!')
     c = c';
end

l = size(c,1);
if l < size(X,2)
     c = [c; zeros(size(X,2)-l,size(c,2))];
     warning('Padding c with zeros!')
end

% T and F's could be combined, but done separately
% for pedagogical reasons

if size(c,2)==1
  df = length(y) - rank(X)
  s = r'*r / df;
  t = c'*B / sqrt(s*c'*pinv(X'*X)*c)
  p = t2p(t,df)
  F = t^2; 
  R2 = F2R(F,1,df);
else
  c_0 = eye(size(X,2)) - c*pinv(c);
  X_0 = X*c_0;
  R   = eye(size(X,1)) - X*pinv(X);
  R_0 = eye(size(X,1)) - X_0*pinv(X_0);
  M = R_0 - R;
  df = [rank(X)-rank(X_0) size(X,1)-rank(X)];
  F  = ((B'*X'*M*X*B)/df(1)) / ((y'*R*y)/df(2));  
  p  = 1-spm_Fcdf(F,df);
  t = [];
  R2 = F2R(F,df(1),df(2));
end



%Below doesn't work if constant not included
%R2 = 1 - (r'*r) / (y'*y);   %R2 = (Y'*Y)/(y'*y) equivalent
%disp(sprintf('Overall R2 = %f',R2))
%R2 = 1 - (r'*r/df(end)) / (y'*y/length(y));
%disp(sprintf('Overall Adjusted R2 = %f',R2))


if pflag
	figure(pflag), clf, hold on
	Xc = X*c;
	Yc = Xc*(c'*B);
	plot(Xc,y,'b.')
	plot(Xc,Yc,'r-')
	plot(Xc,Yc+r,'r.')
end

