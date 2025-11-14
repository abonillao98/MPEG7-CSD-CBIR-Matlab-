function [output] = cuentaAciertos(numImgRef, numImgTest)
%CUENTAACIERTOS Summary of this function goes here
%  Se li pasen dos dumeros de imatge
%  Ha de mirar si la imatge input2 es un acierto de la imatge inpu1

%Mitjançant aritmetica modular, es calcula quin es el numero inicial del llistat de la
%imatge de Referencia per a despres fer un vector dels numeros que es
%consideren aciertos
numPrimeraImatge = numImgRef - mod(numImgRef,4);
imatgesAcierto = [numPrimeraImatge,numPrimeraImatge+1,numPrimeraImatge+2,numPrimeraImatge+3 ];

% es comprova si el numero de la imatge a comparar (ImgTest) forma part del
%vector
output = ismember(numImgTest,imatgesAcierto);
end

