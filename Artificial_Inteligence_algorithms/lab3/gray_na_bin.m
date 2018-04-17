function b = gray_na_bin(g)
% funkcja zamieniajaca kod Graya na zwykly kod binarny

b = '';
b(1) = g(1);

for i = 2 : length(g);
    x = xor(str2num(b(i-1)), str2num(g(i)));
    b(i) = num2str(x);
end

end