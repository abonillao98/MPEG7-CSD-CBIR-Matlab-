clear all

% Define Image Database directory and images filename prefix
ImDB_path = [pwd,'\UKentuckyDatabase\'];
ImTest_path = [pwd,'\img\'];
ImDB_name_prefix = 'ukbench';
image_number = 1223;

filename = [ImDB_path, ImDB_name_prefix, sprintf('%05d.jpg',image_number)];
    
    %% 1.1 Conversió a l'espai de color HMMD
    mode = 'HDS'; %mode pot ser HMM o HDS

    % conversio pixel a pixel (amb "prog2_rgb2hmmd.m")
    I_hmmd_pixel = prog2_rgb2hmmd(imread(filename),mode);

    % conversio matricial (amb "prog2_rgb2hmmd_vect.m")
    I_rgb = imread(filename);
    I_hmmd_vector = prog2_rgb2hmmd_vect(I_rgb, mode);

if max(abs(I_hmmd_vector(:) - I_hmmd_pixel(:))) < 1e-12
    disp("Las imágenes son prácticamente iguales");
else
    disp("Hay diferencias significativas");
end

  %% 1.2 Quantitzacio no uniforme de la imatge hmmd   
         
    % Cuantizacion por pixel (usando "prog2_hmmd_quantize.m")
    I_files = size(I_hmmd_pixel,1);
    I_columnes = size(I_hmmd_pixel,2);
    I_hmmd_quantized_pixel = zeros(I_files,I_columnes);
    for ii = 1:(I_files)
        for jj = 1:I_columnes
            I_hmmd_quantized_pixel(ii,jj)=prog2_hmmd_quantize(I_hmmd_pixel(ii,jj,1),I_hmmd_pixel(ii,jj,2),I_hmmd_pixel(ii,jj,3));
        end
    end

    % Cuantizacion optimizado (usando "prog2_hmmd_quantize_opt.m")
    I_files = size(I_hmmd_vector,1);
    I_columnes = size(I_hmmd_vector,2);
    I_hmmd_quantized_opt = zeros(I_files,I_columnes);
    for ii = 1:(I_files)
        for jj = 1:I_columnes
            I_hmmd_quantized_opt(ii,jj)=prog2_hmmd_quantize_opt(I_hmmd_vector(ii,jj,1),I_hmmd_vector(ii,jj,2),I_hmmd_vector(ii,jj,3));
        end
    end
    

if max(abs(I_hmmd_quantized_opt(:) - I_hmmd_quantized_pixel(:))) < 1e-12
    disp("Las cuantificacions son prácticamente iguales");
else
    disp("Hay diferencias significativas cuantificacion");
end

%%
% Matriz booleana de diferencias
diff_matrix = I_hmmd_quantized_opt ~= I_hmmd_quantized_pixel;

% Número total de diferencias
num_diff = sum(diff_matrix(:));
disp(['Número de píxeles diferentes: ', num2str(num_diff)]);

% Coordenadas donde difieren
[row, col] = find(diff_matrix);

% Mostrar primeros ejemplos de diferencias
for k = 1:min(10,num_diff)
    i = row(k);
    j = col(k);
    fprintf('(%d,%d): original=%d, opt=%d\n', i, j, ...
        I_hmmd_quantized_pixel(i,j), I_hmmd_quantized_opt(i,j));
end