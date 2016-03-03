function [stats]=PCAreg(x,y,t)
% PCAreg - principle component analysis orthogonal/ major axis regression
% [output arg]=name(input arg)
%
% input:
% x          x values
% y          y values
% t          t score for required confidence interval (default 95% =  1.96)
%
% output:
% stats structure:
% fit        slope and constant of linear fit, [1*2]
% Exp        R-squared value of fit,           [1]
% CIm        slope confidence intervals,       [1*2]
% CIc        intecept confidence intervals,    [1*2]
% RMSE       root mean square error, (x,y)
% fitVals    evaluation of the fit, [n*2] 
%
% output:
% description [units]...
%
% user defined functions called:
%
% notes

%{
PCAreg, 1.4 (Matlab 2013b)

a 2D perpendicular least squares linear (Orthogonal or major axis) 
regression, using the principal component analysis (PCA).  This method 
assumes that all the variables have error, compared to the standard linear 
regression methods which assumes that only the dependent variable has error
(Math Works, 2013)

notes
tested against polyfit and fitlm (both minimise in the vertical)
tested against Orthogonal Deming regression and they are the same,
https://en.wikipedia.org/wiki/Deming_regression, and it looks better for
logged data than the other method tried


by D. Lichtman, 2014/08/18

user defined functions called:


References:
Borradaile, G. J., 2003. Statistics of Earth Science Data: Their 
Distribution in Time, Space and Orientation. Springer-Verlag: Berlin, 
p. 351

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

Wikipedia, 2015. Explained variance in principal component analysis
Wikipedia [Online] Available at: https://en.wikipedia.org/wiki/
Explained_variation#Explained_variance_in_principal_component_analysis
[Accessed 22 June 2015]. 

update history:
2015/08/25 DL: Updated the confidence intervals for Borradaile (2003)
2015/06/16 DL: Added a structure for statistics. Inf values set to nan
2014/08/20 DL: Commented out R-square calculation as I was't sure the total
               sum of squares calculation was right.  The explained value 
               is equivalent.
2014/08/19 DL: Changed to output the R-squared value as R-squared, as the
               roots derived value is outputting slightly different values
%}

if ~exist('t','var'), t=1.96; end   % 95% CI

% transpose input if required
if size(x,1)<size(x,2), x=x'; end
if size(y,1)<size(y,2), y=y'; end

% PCA regression
% minimises errrors perpendicular to the fit, or in vertical and horizontal
XX=[x,y];
[coef,score,roots]=pca(XX);

% variance explained and error
pctExp=roots'./sum(roots);          % 1st term is equivalent to R squared. 
Exp=pctExp(1);                      % (the amount of variance explained by
                                    % the fit)

% mean values (point of mean or centre point on graph)
[n,~]=size(XX);                     % n is the number of values
meanXX=mean(XX,1);

% regression fit coefficents 
fit=[-coef(1,2)/coef(2,2),meanXX*coef(:,2)/coef(2,2)];
%fit=[coef(2,1)/coef(1,1)]   % axes are at right angles to each other

% evaluated regression fit
fitVals=repmat(meanXX,n,1)+ score(:,1)*coef(:,1)';

% residuals

res=XX-fitVals;                             % residuals/errors in x and y                       

% sum of square errors
error = abs((XX - repmat(meanXX,n,1))*coef(:,2));
SSE = sum(error.^2);

% root mean square error
RMSE=sqrt(SSE/n);

% Confiedence intervals using Borradaile, The Statistics of Earth Science 
% Data, p. 141
CIm(1) = +t*fit(1)*sqrt((1-Exp)/n);    
CIm(2) = -t*fit(1)*sqrt((1-Exp)/n);  

CIc(1)=+t*std(XX(:,2))*sqrt(((1-Exp)/n)*(1+(meanXX(1)^2/std(XX(:,1))^2)));
CIc(2)=-t*std(XX(:,2))*sqrt(((1-Exp)/n)*(1+(meanXX(1)^2/std(XX(:,1))^2)));

% put into a structure for output
stats.fit = fit;
stats.Exp = Exp;
stats.CIm = CIm;
stats.CIc = CIc;
stats.RMSE = RMSE;
stats.fitVals = fitVals;
stats.res = res;