function bin = prog2_hmmd_quantize_128(H, D, S)
% Donat un pixel HMMD (H,D,S) (normalitzat, de 0 a 1) aquesta funció
% retorna un numero entre 0 i 255, indicant el bin del histograma al qual
% pertany.

diff_thresholds = [6, 20, 60, 110] / 255;

%        Hue  Sum
levels = [ 1, 16;  % Subespai 0 - 1*16=16 + 0 = 16 | 1r offset
           4,  4;  % Subespai 1 - 4*4=16 + 16 = 32 | 2n offset
          8,  4;  % Subespai 2 - 8*4=32 + 32 = 64 | 3r offset
          8,  4;  % Subespai 3 - 8*4=32 + 64 = 96 | 4t offset
          8,  4]; % Subespai 4 - 8*4=32 + 96 = 128

% Offset per a cada zona de l'histograma
zone_offsets = [0, 16, 32, 64, 96];  % acumulacio de bins per subespai

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