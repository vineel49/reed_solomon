% Reed Solomon Systematic encoder
% 'bin_input' is the binary input data
% 'd_min' is the minimum distance of the code
% 'gen_poly' is the generating polynomial

function [tx_seq_bin] = RS_encoder(bin_input,d_min,gen_poly,m)

% mapping block of 8 binary bits to 1 symbol in 2^8 constellation (LEFT-MSB)
a_sym = bin_input(1:8:end-7)*2^7 + bin_input(2:8:end-6)*2^6 + bin_input(3:8:end-5)*2^5 + bin_input(4:8:end-4)*2^4+...
    bin_input(5:8:end-3)*2^3 + bin_input(6:8:end-2)*2^2 + bin_input(7:8:end-1)*2^1 + bin_input(8:8:end)*2^0;

% SYSTEMATIC ENCODING for the RS
msg_zero_padded = conv(a_sym,gf([1 zeros(1,d_min-1)],m));
[dummy,rem]=deconv(msg_zero_padded,gen_poly); % rem is the remainder
tx_seq_gf = msg_zero_padded + rem; % symbols are in GF(2^8)

%---  Demapping symbols to binary bits for BPSK modulation-----------------
tx_seq_dec = double(tx_seq_gf.x);
tx_seq_bin = Con_Dec_bin8(tx_seq_dec); % Convert decimal to binary (8 bits)
end