function driverfitn(n)

if nargin < 1
    n = 2;
end
for N = 10.^(1:7)
    fprintf('\nN = %d\n',N);
    data = rand(N,2);
    c = fitn(data,n);
end

end
