function [FS, vt, stats] = featureSelection(X, E, Y, featureAnnot, lambda, numIter, D)
% Feature selection using MultiPEN


% This function is called from: MultiPEN.m
% Outputs:
%           featureSelection.csv
%           which is a table with columns:
%           [name, weight, ranking]
% Inputs:
% X
% E
% Y
% lambda 
% outputDir
% numIter 
% D     decision threshold, typically 0.5 but for some application could be different

%% Feature Selection with MultiPEN 
[weights, vt] = runGenePEN(X, E, Y, lambda, numIter);

%% Rank the feature selection
FS = table();
FS.name = featureAnnot;
FS.weight = weights;
R = tiedrank(abs(weights));
% Reverse the ranking order used in tiedrank
% so that the maximum absolute weight has ranking 1
% and the minimum absoulute weight has the larges ranking
n = numel(R);
FS.ranking = n - (R - 1);
% For features with weight = 0, set "ranking" = 0  (i.e., no selected)
FS.ranking(FS.weight == 0) = 0;


%% Evaluate prediction
stats = evaluatePrediction(X, Y, E, weights, D);
display(stats)
