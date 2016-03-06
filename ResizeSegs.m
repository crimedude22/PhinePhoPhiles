for i = 1:size(f,1)
    [l, fs] = audioread(char(f(i)));
    lt = size(l,1);
    if lt < (fs*.5)
        l(lt:(fs*.5),1) = 0;
    elseif lt > (fs*.5)
        l = l(1:fs*.5);
    end
    audiowrite(char(f(i)),l,fs);
    fprintf(1,'%s went from %d to %d samples long \n',char(f(i)),lt,size(l,1))
end