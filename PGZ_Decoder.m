% DECODING RS Codes - USING PETERSON GORENSTIEN ZIELER ALGORITHM 
% written by Vineel Kumar Veludandi

function [Dec_seq_gf] = PGZ_Decoder(d_min,Rec_seq_gf,N_GF,m)
% syndrome vector - dimension: (d_min-1) X 1.
synd_vect = gf(zeros(1,d_min-1),8); % initialization
for i1 = 1:d_min-1
 synd_vect(i1) = polyval(Rec_seq_gf,gf(2,m)^(i1));   % syndromes
end

% choosing M(w) matrix and checking if it is singular or not
for w = floor((d_min-1)/2):-1:1 % 8 because d_min-1/2 = 8
%w=8; % such 2*w <= d_min-1
Mw_matrix = gf(zeros(w,w),m);
for i1 = 0:w-1
Mw_matrix(i1+1,:) = synd_vect(w+i1:-1:1+i1);    
end

% rank
rnk = rank(Mw_matrix);
if rnk==w
%-----------------------------------------------
% Error position calculation
deltas = inv(Mw_matrix)*synd_vect(w+1:1:2*w)';
deltas = deltas(end:-1:1);
deltas = deltas'; % lamba_1 lambda_2 ... in row format
Delta_roots = transpose(roots(gf([deltas 1],m)));
%- IF CODEWORD LIES OUTSIDE THE SPHERE OF RADIUS 't', then stop decoding---
if length(Delta_roots)~=w
    error_pos_indices = 1:N_GF;
    error_Ys = gf(zeros(1,N_GF),m);
    break
end
%-------------------------------------------------------------------------
Xs = 1./Delta_roots; % X_1 X_2.... row vector
powers_prim = log(Xs); % powers of alpha: primitive element
error_pos_indices = N_GF - powers_prim; % MATLAB NOTATION _ FOLLOW THIS
% 126 power is the first element in Rec_gf_sym
%-----------------------------------------------
% Errors calculation
Error_cal_mat = gf(zeros(w,w),m);
for i1 = 1:w
Error_cal_mat(i1,:) = Xs.^(i1);    
end
% error calculation Ys (error magnitutdes at the locations)
error_Ys = transpose(inv(Error_cal_mat)*synd_vect(1:1:w)');
break

elseif rnk~=w && rnk~=0
continue

elseif rnk==0
    error_pos_indices = 1:N_GF;
    error_Ys = gf(zeros(1,N_GF),m);
end
end
error_correction = gf(zeros(1,N_GF),m); % initialization of error correction vector
error_correction(error_pos_indices) = error_Ys;

Dec_seq_gf = Rec_seq_gf + error_correction;
end