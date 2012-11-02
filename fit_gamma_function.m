function params = fit_gamma_function( gun_values, cd )

params0 = [ 1 1 0 ];
lb      = [ 0 0 0 ];
ub      = [ 5 5 10 ];

[ params, resnorm, residual, exitflag ] = lsqcurvefit(@mon_gamma, params0, gun_values, cd, lb, ub );