function bin = prog2_hmmd_quantize(H, D, S)
% Donat un pixel HMMD (H,D,S) (normalitzat, de 0 a 1) aquesta funció
% retorna un numero entre 0 i 255, indicant el bin del histograma al qual
% pertany.

diff_thresholds = [6, 20, 60, 110] / 255;

%        Hue  Sum
levels = [ 1, 32;  % Subespai 0 - 1*32=32 + 0 = 32 | 1r offset
           4,  8;  % Subespai 1 - 4*8=32 + 32 = 64 | 2n offset
          16,  4;  % Subespai 2 - 16*4=64 + 64 = 128 | 3r offset
          16,  4;  % Subespai 3 - 16*4=64 + 128 = 192 | 4t offset
          16,  4]; % Subespai 4 - 16*4=64 + 192 = 256

% Offset per a cada zona de l'histograma
zone_offsets = [0, 32, 64, 128, 192];  % acumulacio de bins per subespai

% Deteccio de subespai
zone = find(D < diff_thresholds, 1);
if isempty(zone)
    zone = 5;
end

hue_levels = levels(zone,1);
sum_levels = levels(zone,2);

% Evitar desbordaments per valors = 1.0
epsilon = 1e-10;
H = min(H, 1 - epsilon);
S = min(S, 1 - epsilon);

% Quantització
h_q = floor(H * hue_levels);
s_q = floor(S * sum_levels);

% Índex global del bin
bin = zone_offsets(zone) + s_q * hue_levels + h_q;
end