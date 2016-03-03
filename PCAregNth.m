function [fit,CI,Exp,fitVals]=PCAregNth(x)

%{
PCAreg, 1.0 (Matlab 2013b)

a nD perpendicular least squares linear regression, using the principal 
component analysis (PCA).  This method assumes that all the variables have 
error, compared to the standard linear regression methods which assumes 
that only the dependent variable has error (Math Works, 2013).

by D. Lichtman, 2014/11/04

input:
x          Array of values, [n*n]

output:
fit        slope and constant of linear fit, [1*2]
CI         95% confidence intervals, (x,y), [2*2]
Exp        explained variance of fit (R-squared values of fit)
fitVals    evaluation of the fit, [n*2] 

user defined functions called:


References:
Golub, G. H. and van Loan, C. F.,1980, An analysis of the total least 
squares problem. SAIM Journal of Numerical Analysis, 17(6), pp. 883-893.

Math Works Inc., 2013.  Fitting an Orthogonal Regression Using Principal 
Components Analysis. [Online] Available at:
http://www.mathworks.co.uk/help/stats/examples/
fitting-an-orthogonal-regression-using-principal-components-analysis.html 
[Accessed 18 August 2014].

Weisstein, Eric W., 2014. Correlation Coefficient. MathWorld-A Wolfram Web
 Resource. [Online] Available at: http://mathworld.wolfram.com/
CorrelationCoefficient.html [Accessed 18 August 2014]. 

Wikipedia, 2014. Coefficient of determination (R-squared). Wikipedia 
[Online] Available at: http://en.wikipedia.org/wiki/R-squared 
[Accessed 18 August 2014]. 

update history:
2016/02/19 DL: bug fixed. 
2014/11/04 DL: Extended for n dimensions.
2014/08/21 DL: Extended to fit surface (3D).

2014/08/20 DL: Commented out R-square calculation as I was't sure the total
               sum of squares calculation was right.  The explained value 
               is equivalent.

2014/08/19 DL: Changed to output the R-squared value as R-squared, as the
               roots derived value is outputting slightly different values
%}

%% Main function

% PCA regression
% minimises errrors perpendicular to the fit, or in vertical and horizontal


% transpose input if required
%{
if size(x,1)<size(x,2), x=x'; end
if size(y,1)<size(y,2), y=y'; end
if size(y,1)<size(y,2), z=z'; end
%}


switch nargin
    case 1
        XX=x;
    case 2    
        XX=[x,y];
    case 3
        XX=[x,y,z];
end


[n,p]=size(XX);

%principal component analysis
[coef,score,roots]=pca(XX);

% variance explained and error
pctExp=roots'./sum(roots);   % sum of n-1 terms is equivalent to R squared. 
Exp=pctExp(1:p-1);      % (the amount of variance explained by
                             % the fit)

% mean values (point of mean or centre point on graph)
meanXX=mean(XX,1);

% regression fit coefficents 
% =((1/normal(3).*(meanX*normal -x.*normal(1) -y.*normal(2)) MathWorks,2013
switch p
    case 2
fit=[-coef(1,p)/coef(p,p),meanXX*coef(:,p)/coef(p,p)];
    case 3
fit=[-coef(1,p)/coef(p,p),-coef(2,p)/coef(p,p),meanXX*coef(:,p)/coef(p,p)];
end    
%{
for ii=1:p-1   % for more than 3 dimensions
    fit(ii)=-coef(ii,p)/coef(p,p);
end    
fit(3)=meanXX*coef(:,p)/coef(p,p);
%}

% evaluated regression fit
fitVals=repmat(meanXX,n,1)+ score(:,1)*coef(:,1)';

% sum of squares of errors/residuals (SSE), total sum of squares and R^2
res=XX-fitVals;                                % residuals in x and y

%err=abs((XX-repmat(meanXX,n,1))*coef(:,2));   % magnitude of the residuals
%SSE=sum(err.^2);                               % SSE for magnitude
%SST=sum((XX-repmat(meanXX,n,1)).^2);          % SST for magnitude
%SST=sum(((XX-repmat(meanXX,n,1))*coef(:,1)).^2); % SST for magnitude
%Rsq=1-SSE./SST;                           

% confidence intervals for x and y
CI(1,:)=+1.96*std(res)/sqrt(length(res));   %x,y
CI(2,:)=-1.96*std(res)/sqrt(length(res));   %x,y
if CI==inf, CI(CI==inf)=0; end

%{
% R-squared (only in y)
SST=sum((y-mean(y)).^2);      % total sum of squares
SSE=sum((y-fitVals(:,2)).^2); % sum of squares of errors/residuals
Rsq=1-SSE/SST;  
%}





