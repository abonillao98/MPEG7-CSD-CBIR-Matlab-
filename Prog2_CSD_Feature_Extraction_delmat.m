clear all

% Define Image Database directory and images filename prefix
ImDB_path = [pwd,'\UKentuckyDatabase\'];
ImTest_path = [pwd,'\img\'];
ImDB_name_prefix = 'ukbench';
% Parameters for feature extraction
hist_bins = 256;
num_images = 2000;

H_CSD_delmat = zeros(num_images,hist_bins);

disp(['Hora inicio procesado pixel a pixel con delmado ', num2str(num_images),' imagenes con ', num2str(hist_bins), ' bins: '   datestr(now, 'dd/mm/yy-HH:MM')]);
tic

% Nomes imatges test:
% '8x8_test_rgb_vertical_strip.png'
% '16x8_test_rgb_rgb-barreja_vertical.png'
%filename_test = [ImTest_path, '16x8_test_rgb_rgb-barreja_vertical.png'];

%% 0 Implementació de funció prog2_rgb2hsv per veure que estem implementant
%  bé una funció d'aquest tipus, comparant la nostra amb la propia de
%  Matlab. L'error absolut es tan baix que la donem per bona
% 
% I_hsv = rgb2hsv(imread(filename));
% I_prog2_hsv = prog2_rgb2hsv(imread(filename));
% 
% max_abs_error = max(abs(I_hsv(:) - I_prog2_hsv(:)));
% disp(['Error absoluto máximo: ', num2str(max_abs_error)]);
% 
% if max_abs_error < 1e-10
%     disp(['Error indistinguible']);
% else
%     disp(['Error notable']);
% end

% El estandar MPEG-7 defineix el factor de delmat o "subsampling" K = 2^p 
% on p = max{0, floor(log2(sqrt(W*H))-7.5)}
% Totes les imatges son 640x480
W=640;
H=480;
p = floor(log2(sqrt(W*H))-7.5);
K = 2^p;



%% Inici bucle principal
for i = 0:(num_images-1)
    filename = [ImDB_path, ImDB_name_prefix, sprintf('%05d.jpg',i)];


    %% 1.1 Conversió a l'espai de color HMMD
    mode = 'HDS'; %mode pot ser HMM o HDS

    % Leer imagen
    I_rgb = imread(filename);
    
    % Convertir a double para precisión en el filtrado
    I_rgb = im2double(I_rgb);
    
    % Definir un filtro pasabajo 
    h = fspecial('gaussian', [5 5], 1);  % sigma = 1
    
    % Aplicar el filtro a cada canal RGB
    I_filt(:,:,1) = imfilter(I_rgb(:,:,1), h, 'replicate');
    I_filt(:,:,2) = imfilter(I_rgb(:,:,2), h, 'replicate');
    I_filt(:,:,3) = imfilter(I_rgb(:,:,3), h, 'replicate');

    % delmat con paso K
    I_subsampled = I_filt(1:K:end, 1:K:end, :); % Selecciona una de cada K filas y columnas
    
    % Conversión RGB a HMMD
    I_hmmd = prog2_rgb2hmmd(I_subsampled, mode); % Usa aquí la imagen subsampleada

    %% 1.2 Quantitzacio no uniforme de la imatge hmmd   
         
    % Cuantizacion por pixel (usando "prog2_hmmd_quantize.m")
    I_files = size(I_hmmd,1);
    I_columnes = size(I_hmmd,2);
    I_hmmd_quantized = zeros(I_files,I_columnes);
    for ii = 1:(I_files)
        for jj = 1:I_columnes
            I_hmmd_quantized(ii,jj)=prog2_hmmd_quantize(I_hmmd(ii,jj,1),I_hmmd(ii,jj,2),I_hmmd(ii,jj,3));
        end
    end
    
    % cuantizacion por matriz (usando "prog2_hmmd_quantize_vect.m")
    %I_hmmd_quantized = prog2_hmmd_quantize_vect(I_hmmd(:,:,1), I_hmmd(:,:,2), I_hmmd(:,:,3));
    
    
    %% 2 Escombrat de la imatge amb la bola 8x8
    
    %Cada posicio "k" del csd_hist representa el numero de boles 8x8 en las que
    %apareix al menys una vegada el bin "k"
    csd_hist = zeros(1, 256);  % Inicializa histograma
    
    tamany_bola = 8;
    
    I_q = I_hmmd_quantized;
    I_files = size(I_q,1);
    I_columnes = size(I_q,2);
    
    for kk = 1:(I_files - tamany_bola + 1)
        for ll = 1:(I_columnes - tamany_bola + 1)
    
            % Extraer bloque 8x8 con solapamiento
            block = I_q(kk:kk+tamany_bola-1, ll:ll+tamany_bola-1);
    
            % Encuentra los bins únicos presentes en el bloque
            bins_present = unique(block);
    
            % Incrementa el histograma una vez por bin presente en el bloque
            csd_hist(bins_present + 1) = csd_hist(bins_present + 1) + 1;
        end
    end
    
    
    %% 3 Normalitzacio i quantitzacio no lineal
    
    % normalitzacio
    csd_hist = csd_hist / sum(csd_hist);
    
    % quantitzacio no lineal
    a = 0.4;
    csd_quantized = round( (log(1 + a * csd_hist) / log(1 + a)) * 255 );

    H_CSD_delmat(i+1,:) = csd_quantized;
end

toc
disp(['Hora finalizacion procesado delmat ', num2str(num_images),' imagenes con ', num2str(hist_bins), ' bins: '   datestr(now, 'dd/mm/yy-HH:MM')]);

save(['H_CSD_',num2str(num_images),'imgs_',num2str(hist_bins),'bins_delmat'],"H_CSD_delmat")
