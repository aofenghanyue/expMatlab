function [x,fval,exitflag,output,population,score] = ga_mis2tar_start(nvars,lb,ub,PopulationSize_Data,MaxGenerations_Data)
%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'PopulationSize', PopulationSize_Data);
options = optimoptions(options,'MaxGenerations', MaxGenerations_Data);
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'PlotFcn', { @gaplotbestf });
options = optimoptions(options,'UseParallel', true);
[x,fval,exitflag,output,population,score] = ...
ga(@ga_mis2tar,nvars,[],[],[],[],lb,ub,[],[],options);
