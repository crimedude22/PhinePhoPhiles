function cb_changename(src,evt)
    global rtlist
    num = src.UserData;
    rightrow = findall(gcf,'UserData',num);
    rightbox = findall(rightrow,'Style','edit');
    text = rightbox.String;
    rtlist(num) = text;
end