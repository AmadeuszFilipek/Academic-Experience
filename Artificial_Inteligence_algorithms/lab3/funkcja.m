function y = funkcja(x,gray)
if ~isvector(x)
    error('Input must be a vector')
end
y = (-1+ bi2de(x', gray)*3/(2^22-1))*sin(10*pi*(-1+ bi2de(x', gray)*3/(2^22-1)))+1 ; 
end