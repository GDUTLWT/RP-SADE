function options = deoptions
options.MaxIt = 1000;      % Maximum Number of Iterations
options.nPop = 200;        % Population Size
options.beta_min = 0.2;   % Lower Bound of Scaling Factor
options.beta_max = 0.8;   % Upper Bound of Scaling Factor
options.pCR= 0.5;        % Crossover Probability
options.pMu = 0.5;
options.Tol = 1e-3;
options.IniPop = [];
options.surrogate = 0;