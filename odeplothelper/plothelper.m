function plotHelper(X,Y,sel,stylenames,styles,legendstr)
%PLOTHELPER convenience function for graphic the results of ODE solvers such as ode45 and ode15s.
% X, Y are the solution vectors as defined in the solution struct returned by the solver. 
% stylenames and styles are cell arrays with the styles for the graphs. For example,
% stylenames = {'LineStyle','LineWidth','Color'} and 
% styles = {'-','-','-.','-.','-'; 2 2 2 2 2; [0 0 1] [0 0.5 0] [1 0 0] [0 0 0] [0 0 0]}'
% sel are the solution indices to graph. lengendstr is cell array with legend entries.

hold on
p = plot(X,Y(sel,:));
set(p,stylenames,styles(sel,:));
hold off
axis tight;
legend(legendstr{sel});
end
