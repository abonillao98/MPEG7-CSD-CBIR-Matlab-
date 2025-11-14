function hmmd_image_out = prog2_rgb2hmmd_vect(rgb_image_in, mode)
% Versió vectoritzada de RGB a HMMD (HMM o HDS)
% Retorna una imatge de la mateixa mida amb 3 canals: (H, Max+Min o Diff, Min o Sum)

if nargin < 2
    mode = 'HDS';
end

% Si RGB està en uint8, normalitza a [0,1]
if isa(rgb_image_in, 'uint8')
    rgb_image_in = double(rgb_image_in) / 255;
end

R = rgb_image_in(:,:,1);
G = rgb_image_in(:,:,2);
B = rgb_image_in(:,:,3);

MaxVal = max(cat(3,R,G,B), [], 3);
MinVal = min(cat(3,R,G,B), [], 3);
Diff = MaxVal - MinVal;
Sum  = (MaxVal + MinVal) / 2;

Hue = zeros(size(R));
mask = (Diff ~= 0);  % on hi ha diferència entre canals

% Càlcul de Hue segons HSV
R_m = R(mask); G_m = G(mask); B_m = B(mask); D_m = Diff(mask); Mx = MaxVal(mask);
hue = zeros(size(R_m));

% Condicions vectoritzades
condR_Gb = (Mx == R_m) & (G_m >= B_m);
condR_Gl = (Mx == R_m) & (G_m < B_m);
condG = (Mx == G_m);
condB = (Mx == B_m);

hue(condR_Gb) = 60 * (G_m(condR_Gb) - B_m(condR_Gb)) ./ D_m(condR_Gb);
hue(condR_Gl) = 360 + 60 * (G_m(condR_Gl) - B_m(condR_Gl)) ./ D_m(condR_Gl);
hue(condG)    = 60 * (2 + (B_m(condG) - R_m(condG)) ./ D_m(condG));
hue(condB)    = 60 * (4 + (R_m(condB) - G_m(condB)) ./ D_m(condB));

Hue(mask) = hue / 360;  % normalitzar a [0,1]

% Assignació final segons mode
hmmd_image_out = zeros(size(rgb_image_in));
hmmd_image_out(:,:,1) = Hue;

if strcmp(mode, 'HMM')
    hmmd_image_out(:,:,2) = MaxVal;
    hmmd_image_out(:,:,3) = MinVal;
else  % HDS
    hmmd_image_out(:,:,2) = Diff;
    hmmd_image_out(:,:,3) = Sum;
end
end
