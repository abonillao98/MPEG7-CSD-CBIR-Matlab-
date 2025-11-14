function [distancia] = distancia4_variable(h1,h2,tipus)
% Es una metrica de similitud. Quant menor sigui el valor 'distancia', més s'asemblen
% els histogrames 'h1' i 'h2'.

%es normalitzen els histogrames:
h1 = h1 / sum(h1);
h2 = h2 / sum(h2);

if strcmp(tipus,'taxi')
    %Calcuula la diferencia absoluta entre dos histogrames i retorna la suma total.
    distancia = sum(abs(h1-h2));
elseif strcmp(tipus,'hellinger')
    distancia = sqrt(0.5) * sqrt(sum((sqrt(h1) - sqrt(h2)).^2));
elseif strcmp(tipus,'mae')
    distancia = mean(abs(h1 - h2));
elseif strcmp(tipus,'chi2')
    distancia = sum(((h1 - h2).^2) ./ (h1 + h2 + eps));
else
    distancia = sum(abs(h1-h2));
end


end