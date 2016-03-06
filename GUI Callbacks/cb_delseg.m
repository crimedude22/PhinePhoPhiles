function cb_delseg(src,evt)
global rtlist;  
global newsegs;
global newlimits;

    num = src.UserData;
    if src.UserData == 1
        newsegs = newsegs(2:end);
        newlimits = newlimits(2:end,:);
    else
        newsegs = [newsegs(1:num-1), newsegs(num+1:end)];
        newlimits = [newlimits(1:num-1,:), newlimits(num+1:end,:)];
    end
    
    uiobjs = findall(gcf,'Type','uicontrol');
    thisbox = findall(gcf,'UserData',num);
    
    for i = 1:numel(thisbox)
        thisbox(i).BackgroundColor = 'k';
        thisbox(i).UserData = 0;
        thisbox(i).Callback = [];
    end
    
    for i = 1:numel(uiobjs)
        objnum = uiobjs(i).UserData;
        if objnum > num
            uiobjs(i).UserData = objnum-1;
            if strcmp(uiobjs(i).Style,'edit')
                uiobjs(i).String = rtlist(uiobjs(i).UserData);
            end
        end
    end
end