function cb_savesegs(src,evt)
    global rtlist
    global newsegs
    global newlimits
    global pholist
    global fs
    rtlist = rtlist(1:length(newsegs));
    
    %Make directories
    savefolder = uigetdir;
    cd(savefolder);
    speaker = input('What is the name of the Speaker?: ','s');
    savefolder = strcat(savefolder,'/',speaker,'/');
    
    if ~exist(savefolder,'dir')
        mkdir(savefolder);
    end
    
    %make directory structure if it doesn't exist
    alldirs = {'C','CV','CVC','V','VC','Words'};
    for i = 1:length(alldirs)
        subdir = strcat(savefolder,alldirs{i},'/');
        if ~exist(subdir,'dir')
            mkdir(subdir);
            switch i
            case 1
                for l = 1:numel(pholist.c)
                    mkdir(subdir,pholist.c{l});
                end
            case 2
                for l = 1:numel(pholist.cv)
                    mkdir(subdir,pholist.cv{l});
                end
            case 3
                for l = 1:numel(pholist.cvc)
                    mkdir(subdir,pholist.cvc{l});
                end
            case 4
                for l = 1:numel(pholist.v)
                    mkdir(subdir,pholist.v{l});
                end
            case 5
                for l = 1:numel(pholist.vc)
                    mkdir(subdir,pholist.vc{l});
                end
            case 6
                for l = 1:numel(pholist.words)
                    mkdir(subdir,pholist.words{l});
                end
            end
        end

    end
    
    
    
    %Make folder switching array to point segs in the right direction
    folderswitch = {};
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
    for k = 1:length(newsegs)
        savefile = char(strcat(savefolder,folderswitch{k},'/',rtlist{k},'/',rtlist{k},'1.wav'));
        numrec = 2;
        while exist(savefile,'file') %increment the number at the end of the file
            savefile = char(strcat(savefolder,folderswitch{k},'/',rtlist{k},'/',rtlist{k},num2str(numrec),'.wav'));
            numrec = numrec + 1;
        end
        try
            audiowrite(savefile,newsegs{k},fs);
        catch
            makenewpath = fileparts(savefile);
            mkdir(makenewpath);
            audiowrite(savefile,newsegs{k},fs);

            
    end

end