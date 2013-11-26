function [coeff] = fitn(xdata,ydata,n)
%FITN Solves least squares problem for data, returning n-degree polynomial fit.

if nargin < 3
    n = 1;
    fprintf('degree not specified. defaulting to n=1\n');
    if nargin < 2
        error('not enough data specified!');
    end
end

%xdata and ydata should have same size and both be vectors
if size(xdata) ~= size(ydata) || ~isvector(xdata) || ~isvector(ydata)
    error('xdata and ydata must be vectors of equal length');
end
%we need columns
if isrow(xdata)
    xdata = xdata';
    ydata = ydata';
end

X = zeros(length(data(:,1)), n+1);
X(:,1) = 1; %set first column to all 1's
for k = 1:n %set the nth column to xdata.^(n-1)
    X(:,k+1) = data(:,1).^k;
end

L = X'*X;   %LHS of normal equations
r = X'*data(:,2);   %RHS
coeff = L\r;
end
