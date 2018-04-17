function y = bi2de(x, gray)
% funkcja zamieniajaca postac binarna chromosomu na postac dziesietna

if gray == 0
    lancuch = num2str(x);
    lancuch = lancuch(~isspace(lancuch));
    y = bin2dec(lancuch);
    %y = -1 + y * 3 / (2^length(x) - 1);
else
    lancuch = num2str(x);
    lancuch = lancuch(~isspace(lancuch));
    lancuch = gray_na_bin(lancuch);
    y = bin2dec(lancuch);
    %y = -1 + y * 3 / (2^length(x) - 1);
end

end