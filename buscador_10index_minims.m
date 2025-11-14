function [outputArg1] = buscador_10index_minims(input)
% Ordena les distancies calculades i retorna els indexs de les 10 imatges mes similars    
    input_sorted = sort(input);
    
    for i=1:10
        indexes(i) = find(input == input_sorted(i),1,'last');
    end
    outputArg1 = indexes -ones(1,10);
end