
% Preprocess

x = wavread('wishes8000');
x = offset_compensation( x );
x = pre_emphasis( x );

% Number of frames

samples_per_frame = 160;
frames = floor(length(x)/samples_per_frame);

%
filename = 'finalA.wav';
x_out = zeros(length(x),1);
for u = 1:frames
   
    %LARc        = Eight quantized LOG-AREA Ratios for the current frame
    %CurrFrmResd = Residual d for current frame 
    [LARc,CurrFrmResd] = RPE_frame_ST_coder(x((u-1) * samples_per_frame + 1:(u-1) * samples_per_frame + samples_per_frame));
   
    [x0]=RPE_frame_ST_decoder(LARc,CurrFrmResd); % frame's samples
    x_out((u-1) * samples_per_frame + 1:(u-1) * samples_per_frame + samples_per_frame) = x0;
end

wavwrite(x_out, filename);


