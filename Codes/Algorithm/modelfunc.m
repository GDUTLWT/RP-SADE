function [y,g] = modelfunc(x)
global dmodel
[y,g] = predictor(x,dmodel);