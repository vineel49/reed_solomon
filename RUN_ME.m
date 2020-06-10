% Reed Solomon coded BPSK over AWGN
% RS code in GF(2^8=256)(this program works for m=8 only)
% error correcting capability 't' = floor((33-1)/2).
% primitive polynomial is D^8+D^4+D^3+D^2+1 (285 decimal)
% written by Vineel Kumar Veludandi

clear
clc
num_frames = 1; % simulation runs
N_GF = 256; % 'N' :(N,N-d_min+1 ,d_min): (N,K,d_min)
t = 32; % 't': radius of the bounded sphere: error correcting capability
d_min = 2*t+1; % minimum distance of the RS code: should be odd number:
K_GF = N_GF-d_min+1; 
% DONOT CHANGE THIS
m = 8; % dimension of the finite field: 2 is the characterstic: GF(2^8)
data_size = K_GF*m;

SNR_dB = 6; % SNR per bit in dB

% -- GENERATOR POLYNOMIAL FOR THE RS code ------------
gen_poly = Gen_Poly_RS(m,d_min);
%---------------------------------
% SNR parameters 
SNR = 10^(0.1*SNR_dB); % in linear scale
Noise_Var_1D = N_GF/(2*K_GF*SNR); % 1D noise variance
%----------------------------------------------------------------
C_Ber = 0; % channel errors
tic()
for frame_cnt = 1:num_frames
% binary source
a = randi([0 1],1,data_size);

% RS encoder
tx_seq_bin = RS_encoder(a,d_min,gen_poly,m);

% BPSK modulation
tx_seq_bpsk = 1-2*tx_seq_bin;

%---- AWGN channel-------------------
noise = normrnd(0,sqrt(Noise_Var_1D),1,length(tx_seq_bpsk)); % WGN noise generation
Chan_Op = tx_seq_bpsk  + noise;

%----------- RECEIVER -----------------------------------------------------
% Hard Decision
rec_bit = Chan_Op<0; % ML decoding

% RS decoder
dec_a = RS_decoder(rec_bit,d_min,m,K_GF,N_GF);

C_Ber = C_Ber + nnz(a-dec_a);

end
toc()
BER = C_Ber/(data_size*num_frames)


