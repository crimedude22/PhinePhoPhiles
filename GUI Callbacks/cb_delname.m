function cb_delname(src,evt)
global rtlist;  
    num = src.UserData;
    boxes = findall(gcf,'Style','edit');
    if num == 1
        rtlist = rtlist(2:end);
    else
        rtlist = [rtlist(1:num-1), rtlist(num+1:end)];
    end
    for i = 1:numel(boxes)
        boxnum = boxes(i).UserData;
        if boxnum >= num 
            boxes(i).String = rtlist(boxnum);
        end
    end
end