function [hsv_image_out] = prog2_rgb2hsv(rgb_image_in)
% Implementacio de la funcio rgb2hsv
% La entrada es una imatge de l'espai de color RGB
% La sortida es la imatge d'entrada convertida a l'espai de color HSV

hsv_image_out = zeros(size(rgb_image_in,1),size(rgb_image_in,2),3);

rgb_image_in = double(rgb_image_in) / 255; % Es normalitza la imatge d'entrada

for i = 1:size(rgb_image_in,1)
    for j = 1:size(rgb_image_in,2)
        % Calcul de Max i Min
        maxx=max(rgb_image_in(i,j,:));
        minn=min(rgb_image_in(i,j,:));

        % Calcul del Hue
        r = rgb_image_in(i,j,1);
        g = rgb_image_in(i,j,2);
        b = rgb_image_in(i,j,3);

        if maxx == minn
            hue = 0;
        elseif (maxx == r) && (g >= b)
            hue = 60*((g-b)/(maxx-minn));
        elseif (maxx == r) && (g < b)
            hue = 360 + 60*((g-b)/(maxx-minn));
        elseif g == maxx
            hue = 60*(2.0+ ((b-r)/(maxx-minn)));
        else 
            hue = 60*(4.0+ ((r-g)/(maxx-minn)));
        end

        hue = hue / 360; % Es normalitza el valor de Hue

        % Calcul del Saturation
        if maxx == 0
            saturation = 0;
        else
            saturation = (maxx-minn)/maxx;
        end

        value=maxx;

        hsv_image_out(i,j,1)=hue;
        hsv_image_out(i,j,2)=saturation;
        hsv_image_out(i,j,3)=value;


    end
end
end

