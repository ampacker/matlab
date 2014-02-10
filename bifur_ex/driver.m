function driver
%DRIVER generate crude solution plots for a quick check on asymptotic behavior.
%   model.m shows both the for and parfor versions of the loop as an
%   example for modifying an existing for loop to work with parfor. Great
%   for the increase in speed.

tic;
[d_R,steadys] = model(40, true);
toc

% if bored and want to see difference with non-parfor for loop
% tic;
% [d_R,steadys] = model(40, false);
% toc

stylemin = {'--','--','--','--','--'; 1 1 1 1 1; [0 0 1] [0 0.5 0] [1 0 0] [0 0 0] [0 0 0]}';
stylemax = {'-.','-.','-.','-.','-.'; 1 1 1 1 1; [0 0 1] [0 0.5 0] [1 0 0] [0 0 0] [0 0 0]}';
legendstr = {'Y','X','Q','N'};
plotter = getplothelper(d_R,steadys,legendstr,stylemin,stylemax);

figure(1)
clf
plotter([1 2]);

figure(2)
clf
plotter([3]);

end

function helperfun = getplothelper(X,Y,legendstr,stylemin,stylemax)
%because writing the same plot(...) lines over and over is a drab
%TODO show single legend entry for single solution's min/max plots

helperfun = @(sel,ismin)plothelper(sel);

    function plothelper(sel)
        ind = 1+2*(sel-1);  %indices for min values
        p = plot(X,Y(ind,:));
        hold on;
        set(p,{'LineStyle','LineWidth','Color'},stylemin(sel,:));
        
        p = plot(X,Y(ind+1,:)); %max's
        set(p,{'LineStyle','LineWidth','Color'},stylemax(sel,:));
        axis tight;
        legend(legendstr{sel});
    end
end
