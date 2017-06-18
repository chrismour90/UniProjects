
% Preprocess

x = audioread('wishes8000');
x = offset_compensation( x );
x = pre_emphasis( x );

% Number of frames

samples_per_frame = 160;
frames = floor(length(x)/samples_per_frame);


% k(u) first sample of each frame

k = zeros(1, frames);
for u = 1:frames
    k(u) = (u-1)*samples_per_frame;
end


% First frame is zero
CurrFrmResd = zeros(1, samples_per_frame);
CurrFrmResdr = zeros(1, samples_per_frame);
filename = 'FinalB.wav';
x_dec = zeros(length(x),1);
for u = 2:frames
    PrevFrmResd = CurrFrmResd;
    PrevFrmResdr = CurrFrmResdr;
    
    %Coder 
    
    %PrevFrmResd =  d(n) of the previous frame
    %LARc        = Eight quantized LOG-AREA Ratios for the current frame
    %Nc = encoded long term correlation lag
    %bc = encoded associated gain factor
    %currFrmExFull = Vector with the total prediction error e
    %CurrFrmResd = The d' sequence of the current frame
    [LARc, Nc, bc, currFrmExFull, CurrFrmResd] = RPE_frame_SLT_coder(x((u-1) * samples_per_frame + 1:(u-1) * samples_per_frame + samples_per_frame), PrevFrmResd);
    
    %Decoder
    [s0,CurrFrmResdr]=RPE_frame_SLT_decoder(LARc,Nc,bc,currFrmExFull,PrevFrmResdr);
    x_dec((u-1) * samples_per_frame + 1:(u-1) * samples_per_frame + samples_per_frame) = s0;
end

wavwrite(x_dec, filename);


