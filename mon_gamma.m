function i = mon_gamma( params, gun_values )

alpha_v =   params(1)*ones( size( gun_values ) );
gamma_v =   params(2)*ones( size( gun_values ) );
beta_v  =   params(3)*ones( size( gun_values ) );

i = alpha_v + gun_values.^( gamma_v ) + beta_v;