function coeff = linearFit(xdata, ydata)
%linearFit solves least squares problem for (xdata,ydata) data.
%   

X = [ones(length(xdata),1) xdata];  %create X matrix
L = X'*X;   %LHS of normal equations
r = X'*ydata;   %RHS
coeff = L\r;
end
