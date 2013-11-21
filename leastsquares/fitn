function [c] = fitn(data,n)
%FITN Solves least squares problem for data, returning n-degree polynomial
%fit. Data should be nx2 matrix, where col1=xdata, col2=ydata
%   Detailed explanation goes here

if nargin < 2
    n = 1;
    fprintf('degree not specified. defaulting to n=1\n');
    if nargin < 1
        error('no data specified!');
    end
end

%TODO: error checking on data matrix size
X = zeros(length(data(:,1)), n+1);
X(:,1) = 1;
for k = 1:n
    X(:,k+1) = data(:,1).^k;
end

L = X'*X;   %LHS of normal equations
r = X'*data(:,2);   %RHS

% solve using Cholesky decomposition
tic;
U = chol(L);
w = U'\r; % solve the normal equations using the Cholesky decomposition
c = U\w;
toc;

% is the magical backslash operator is faster when using X'X=X'y
tic;
c1 = L\r;
toc;

%... or when simply using X\y?
tic; c2 = X\data(:,2); toc;

%assume c1 is "true" solution
err1 = norm(c-c1);
err2 = norm(c-c2);
fprintf('Error1: %f\nError2: %f\n',err1,err2);

end
