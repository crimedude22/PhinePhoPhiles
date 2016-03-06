function cb_insname(src,evt)
global rtlist;  
    num = src.UserData;
    boxes = findall(gcf,'Style','edit');
    if num == 1
        rtlist = [' ',rtlist];
    else
        rtlist = [rtlist(1:num-1),' ', rtlist(num:end)];
    end
    for i = 1:numel(boxes)
        boxnum = boxes(i).UserData;
        if boxnum >= num 
            boxes(i).String = rtlist(boxnum);
        end
    end
end