function [R,steadys] = model(N_sol, useparfor)
%MODEL generate crude solution plots for a quick check on asymptotic behavior.
%   model.m shows both the for and parfor versions of the loop as an
%   example for modifying an existing for loop to work with parfor. Great
%   for the increase in speed.

if nargin<2
    useparfor = true;
    if nargin<1
        N_sol = 50;
    end
end

%% test params
tspan = [0 1800];
T = 0.3;
theta = 0.2;
q = 0.1;
r = 0.8;
d = 0.20;
mum = 1.2;

Y0 = 0.2;
X0 = 0.4;
Q0 = 2*q;

%% test functions
s = 0.8;
sk = 0.25;
flinear = @(x)s*x;
fmonod = @(x)s*x./(x+sk);

cm = 0.01;
ck = 1;
clinear = @(x)cm*x;
chill = @(x)cm*x./(ck+x);

vm = 0.8;
vk = 1;
vlinear = @(x)vm*x;
vhill = @(x)vm*x./(vk+x);

f = fmonod;
v = vhill;
c = chill;

%% solve and save min/max of purported omega limit sets (should add numerical check)
R = linspace(0.1,1.4,N_sol);
d_R = q*r/theta*f(T/q)./R;
steadys = zeros(8,length(R));

if ~useparfor
    %% Begin slower for loop
    for ind = 1:length(R)
        [tSol,sol] = getSol(d_R(ind));
        tstart = find(tSol>=tspan(2)*0.75,1);
        solsel = sol(:,(tstart:end));
        steadys(1:2:end,ind) = min(solsel,[],2);  %max of rows
        steadys(2:2:end,ind) = max(solsel,[],2);
    end
else
    %% Begin parfor implementation. Note that the prior indexing pattern of
    % "steadys(1:2:end,ind) = ..." is not okay in parfor slicing. The original for loop 
    % sets the min and max as every other element in steadys's columns.
    % Simple fix is use two matrices then merge afterwards.
    minsol = zeros(4,length(R));
    maxsol = zeros(4,length(R));
    getSolfun = @getSol;
    parfor ind = 1:length(R)
        [tSol,sol] = getSolfun(d_R(ind));
        tstart = find(tSol>=tspan(2)*0.75,1);
        solsel = sol(:,(tstart:end));
        minsol(:,ind) = min(solsel,[],2);  %max of rows
        maxsol(:,ind) = max(solsel,[],2);
    end
    steadys(1:2:end,:) = minsol;
    steadys(2:2:end,:) = maxsol;
end

%% solve
    function [tSol,sol] = getSol(delta)
        if nargin==0
            delta = d;  %note scope of d
        end
        
        odesol = ode45(@(t,y)dydt(t,y), tspan, [Y0 X0 Q0]);
        tSol = odesol.x;
        Ysol = odesol.y(1,:);
        Xsol = odesol.y(2,:);
        Qsol = odesol.y(3,:);
        Nsol = T-Qsol.*Xsol-theta.*Ysol;
        
        sol = [odesol.y; Nsol];
        
        function yprime = dydt(~,y)
            Y = y(1,:); X=y(2,:); Q=y(3,:);
            
            N = T-Q.*X-theta*Y;
            yprime = [r*min(1,Q/theta).*f(X).*Y-delta*Y-c(N).*Y
                mum*(1-q./Q).*X-f(X).*Y
                v(N)-mum*(Q-q)];
        end
    end
end

