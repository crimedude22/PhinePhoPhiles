function savesegs(segs)
    global rtlist
    global segs
    rtlist = rtlist(1:length(segs));
    
    %Make directories
    overfolder = uigetdir;
    speaker = input('What is the name of the Speaker?','s');
    speaker = strcat('/',speaker,'/');
    userfolder = strcat(folder,'/',speaker,'/');
    
    if ~exist folder dir
        [suc, mess, mid] = mkdir(overfolder,speaker);
        if suc == 0
            fprintf('%s',suc);
        end
    end
    
    alldirs = {'C','CV','CVC','V','VC','Words'};
    for i = 1:length(alldirs)
        subdir = strcat(userfolder,alldirs(i),'/');
        if ~exist subdir dir
            [suc, mess, mid] = mkdir(subdir);
            if suc == 0
                fprintf('%s',suc);
            end
        end
    end
    
    %Make folder switching array
    for j = 1:length(rtlist)
        if ~isempty(strmatch(rtlist(j),pholist.cv)) 
            folderswitch(j) = {'CV'};
        elseif ~isempty(strmatch(rtlist(j),pholist.vc))
            folderswitch(j) = {'VC'};            
        elseif ~isempty(strmatch(rtlist(j),pholist.cvc))
            folderswitch(j) = {'CVC'};
        elseif ~isempty(strmatch(rtlist(j),pholist.glide))
            folderswitch(j) = {'CV'};
        elseif ~isempty(strmatch(rtlist(j),pholist.c))
            folderswitch(j) = {'C'};
        elseif ~isempty(strmatch(rtlist(j),pholist.v))
            folderswitch(j) = {'V'}; 
        elseif ~isempty(strmatch(rtlist(j),pholist.words))
            folderswitch(j) = {'Words'}; 
        end
    end
    
    %Save segments
    for k = 1:length(segs)
        savefile = strcat(folder,folderswitch(k),'/',rtlist(k),'1.wav');
        while exist savefile file %increment the number at the end of the file
            numrec = 2;
            savefile = strcat(folder,folderswitch(k),'/',rtlist(k),numrec,'.wav');
            numrec = numrec + 1;
        end
        audiowrite(savefile,segs(k),fs);
    end

end