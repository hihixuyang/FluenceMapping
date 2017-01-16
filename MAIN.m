% MAIN - fluence mapping
%
% Requires OptimTraj toolbox and ChebFun toolbox
%
% STATE:  (each row is scalar)
%   x1 = leaf position
%   x2 = leaf position
%
% CONTROL:
%   r = dosage rate
%   v1 = leaf velocity
%   v2 = leaf velocity
%   T1 = leaf position inverse
%   T2 = leaf position inverse
%
% DYNAMICS:
%   (d/dt) x1 = v1
%   (d/dt) x2 = v2
%
% PATH CONSTRAINTs:     (Treated as best-fit soft constraint)
%   0 = t - T1(x1(t))
%   0 = t - T2(x2(t))
%
% BOUNDS:
%   -1 < x1 < 1
%   -1 < x2 < 1
%   0 < T1 < 1
%   0 < T2 < 1
%   0 < u
%   0 < v1
%   0 < v2
%   0 < t < 1
%
% OBJECTIVE:
%   minimize integral (g(x) - f(x))^2
%   f(x) is given
%   g(x) = integral r(t) dt from T1(x) to T2(x)
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~% 

clc; clear; 
addpath ~/Git/OptimTraj
addpath ~/Git/chebFun

%%%% Problem parameters:
nCheb = 11;   % Order of the fitting polynomial
nFit = 3*nCheb;  % Number of points for best-fit curve
tBnd = [0,1];
xBnd = [-1,1];

%%%% Set up a test function to fit:
% f(x) = cos(pi*x/2)
fx = @(x)( cos(0.5*pi*x) );

%%%% Set up the user-defined functions for the optimization:
problem.func.dynamics = @dynamics;
problem.func.pathObj = @(t,x,u)( pathObj(t,x,u,fx,w,xBnd,nFit) );

%%%% set up the bounds for the problem:
problem.bounds.initialTime.low = tBnd(1);
problem.bounds.initialTime.lupp = tBnd(1);
problem.bounds.finalTime.low = tBnd(end);
problem.bounds.finalTime.lupp = tBnd(end);
problem.bounds.initialState.low = [1;1]*xBnd(1);   %[x1;x2]
problem.bounds.initialState.lupp = [1;1]*xBnd(1);
problem.bounds.finalState.low = [1;1]*xBnd(end);
problem.bounds.finalState.lupp = [1;1]*xBnd(end);
problem.bounds.state.low = [1;1]*xBnd(1);
problem.bounds.state.upp = [1;1]*xBnd(end);
problem.bounds.control.low = [zeros(3,1); tBnd(1)*ones(2,1)];
problem.bounds.control.upp = [inf(3,1); tBnd(end)*ones(2,1)];

%%%% Set up an initial guess:




