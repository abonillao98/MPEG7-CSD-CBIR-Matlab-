function [hmmd_image_out] = prog2_rgb2hmmd(rgb_image_in,mode)
% mode pot ser 'HMM' per a (Hue,Max,Min) o 'HDS' per a (Hue,Diff,Sum). 
% Per defecte es HDS.
% Implementacio de la funcio rgb2hmmd
% La entrada es una imatge de l'espai de color RGB
% La sortida es la imatge d'entrada convertida a l'espai de color HMMD

if nargin < 2
    mode = 'HDS';
else
    % Si el mode no es HMM o el mode no es HDS, el mode sera HMM
    if ~strcmp(mode,'HMM') && ~strcmp(mode,'HDS')
        mode = 'HDS';
    end
end

hmmd_image_out = zeros(size(rgb_image_in,1),size(rgb_image_in,2),3);

% Es normalitza la imatge d'entrada en cas de que no ho estigui ja
if isa(rgb_image_in, 'uint8')
    rgb_image_in = double(rgb_image_in) / 255;
end

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

        %Calcul del Difference
        difference = maxx - minn;

        %calcul de sum
        summ = (maxx + minn)/2;

        % Assignacio final segons el mode
        if strcmp(mode,'HMM')
            hmmd_image_out(i,j,1)=hue;
            hmmd_image_out(i,j,2)=maxx;
            hmmd_image_out(i,j,3)=minn;
        else
            hmmd_image_out(i,j,1)=hue;
            hmmd_image_out(i,j,2)=difference;
            hmmd_image_out(i,j,3)=summ;
        end

    end
end
end

