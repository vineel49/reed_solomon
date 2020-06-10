% Generate the generating polynomial for Reed Solomon code
% 'm' is the dimension of the finite field GF(2^m)
% 'd_min' is the minimum distance of the RS code
% Written by Vineel Kumar Veludandi

function [gen_poly] = Gen_Poly_RS(m,d_min)
a2 = gf(2,m);

temp = gf([1 a2],m);

for i1=2:d_min-1
    temp = conv(temp,gf([1 a2^(i1)],m));
end
gen_poly = temp;
end