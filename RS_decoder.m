% Reed Solomon decoder
% 'hard_input' is the hard input to the receiver
% 'hard_bin_op' is the hard output

function [hard_bin_op] = RS_decoder(hard_input,d_min,m,K_GF,N_GF)

% mapping block of 8 bits to decimal symbols (in GF(2^8))
rec_sym = hard_input(1:8:end-7)*2^7 + hard_input(2:8:end-6)*2^6 + hard_input(3:8:end-5)*2^5 + hard_input(4:8:end-4)*2^4+...
    hard_input(5:8:end-3)*2^3 + hard_input(6:8:end-2)*2^2 + hard_input(7:8:end-1)*2^1 + hard_input(8:8:end)*2^0;

% received symbols in GF(2^8)
Rec_seq_gf = gf(rec_sym,m);

%----------------------------------------
% Decode using the Peterson Gorenstein Zieler algorithm
Dec_seq_gf = PGZ_Decoder(d_min,Rec_seq_gf,N_GF,m);

% demapping back to binary bits for error calculation
% Systematic part
Dec_MSG_gf = Dec_seq_gf(1:K_GF); % 111 is the msg length in (127,111,d_min) code

dec_a_sym = double(Dec_MSG_gf.x);
hard_bin_op = Con_Dec_bin8(dec_a_sym);
end