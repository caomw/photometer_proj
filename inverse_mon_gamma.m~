function gun_value = inverse_mon_gamma( params, cd )

beta_v      = ones(size(cd))*params(3);
alpha_v     = ones(size(cd))*params(1);
inv_gamma_v = ones(size(cd))./(ones(size(cd))*params(2));

gun_value = ( ( cd-beta_v )./alpha_v ).^inv_gamma_v;