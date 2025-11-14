function bin = prog2_hmmd_quantize_opt(H, D, S)
% Versió optimitzada de la quantificació HMMD
% Entrada: H, D, S ∈ [0, 1]
% Sortida: bin ∈ [0, 255]

% Constants precalculades
diff_thresholds = [6, 20, 60, 110] / 255;
zone_offsets = [0, 32, 64, 128, 192];
levels = [ 1, 32; 4, 8; 16, 4; 16, 4; 16, 4 ];

% Determinar zona sense usar 'find'
zone = sum(D >= diff_thresholds) + 1;

% Obtenir els nivells corresponents
hue_levels = levels(zone, 1);
sum_levels = levels(zone, 2);

% Truncament ràpid sense funció 'min'
H = H - (H == 1) * eps;
S = S - (S == 1) * eps;

% Quantificació
h_q = floor(H * hue_levels);
s_q = floor(S * sum_levels);

% Càlcul del bin final
bin = zone_offsets(zone) + s_q * hue_levels + h_q;
end
