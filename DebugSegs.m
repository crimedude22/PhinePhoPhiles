function DebugSegs(x, fs, segments, limits, nonpssegs)   
%global segments;
%global fs;
global rtlist;
global newsegs;
global newlimits;
newsegs = segments;
newlimits = limits;%set it for now, will remove bad segments with button fnxn

%Will error if blank space in rtlist
%if length(segments) 

dfig = figure;
dfig.Units = 'normalized';

%init timer
dispstat('','init');
    
% Plot results and play segments:
fprintf('Creating Debugging Environment... \n');
tic
time = 0:1/fs:(length(x)-1) / fs;

% Plot full clip across the top
subplot(4,1,1);
P1 = plot(time, x); set(P1, 'Color', [0.7 0.7 0.7]);

for i=1:length(segments)
    hold on; 
    timeTemp = limits(i,1)/fs:1/fs:limits(i,2)/fs;
    P = plot(timeTemp, segments{i});
    set(P, 'Color', [0.4 0.1 0.1]);
    if mod(i,2) == 0
        text(timeTemp(1),max(x)+.02,num2str(i));
    else
        text(timeTemp(1),max(x)+.07,num2str(i));
    end
    axis([0 time(end) min(x) max(x)+.13]);
end
hold off;

       



    
%Plot all segments and buttons
%if length(segments) < 40 % It takes forever to make these things and they
%can get unstable. 
for i = 1:length(segments)
    %plot # and segment (1/8 width of row)

    scrollsubplot(16,8,41+(8*(i-1))); 
    timeTemp = limits(i,1)/fs:1/fs:limits(i,2)/fs;
    axis([0,max(timeTemp),min(segments{i}),max(segments{i})])
    P2 = plot(timeTemp, segments{i}); set(P2, 'Color', [0.4 0.1 0.1]);
    text(timeTemp(1)-(timeTemp(end)-timeTemp(1))/2,0,num2str(i));
    axis off


    %play button (1/8 width of row)
    %segplayer{i} = audioplayer(segments{i},fs);
    pb = scrollsubplot(16,8,42+(8*(i-1)));
    pbpos = pb.Position;
    pbposvec = [pbpos(1),pbpos(2),pbpos(3),pbpos(4)];
    scrollsubplot(16,8,42+(8*(i-1)));
    axis off
    playb(i) = uicontrol('Parent',dfig,'Style','pushbutton','String','Play','Units','normalized',...
        'Position',pbposvec,'Callback',{@cb_playsound,limits(i,:),fs,nonpssegs},'UserData',i);


    %textbox of seg name (3/8 width of row)
    scrollsubplot(16,8,[43,45]+(8*(i-1)));
    axis off
    tbpos = scrollsubplot(16,8,(43:45)+(8*(i-1)));
    tbposvec = [tbpos.Position(1),tbpos.Position(2),tbpos.Position(3),tbpos.Position(4)];
    tbox = uicontrol('Style','edit','String',[rtlist(i)],'Units','normalized',...
        'Position',tbposvec,'Callback',@cb_changename,'Tag',char(i),'UserData',i);


    %Delete Name button
    scrollsubplot(16,8,46+(8*(i-1)));
    axis off
    dbpos = scrollsubplot(16,8,46+(8*(i-1)));
    dbposvec = [dbpos.Position(1),dbpos.Position(2),dbpos.Position(3),dbpos.Position(4)];
    dbut = uicontrol('Style','pushbutton','String','Del Name','Units','normalized',...
        'Position',dbposvec,'Callback',@cb_delname,'UserData',i);
    
    %Insert Name button
    scrollsubplot(16,8,47+(8*(i-1)));
    axis off
    ibpos = scrollsubplot(16,8,47+(8*(i-1)));
    ibposvec = [ibpos.Position(1),ibpos.Position(2),ibpos.Position(3),ibpos.Position(4)];
    ibut = uicontrol('Style','pushbutton','String','Ins Name','Units','normalized',...
        'Position',ibposvec,'Callback',{@cb_insname},'UserData',i);
    
    %Delete Segment button
    scrollsubplot(16,8,48+(8*(i-1)));
    axis off
    dsbpos = scrollsubplot(16,8,48+(8*(i-1)));
    dsbposvec = [dsbpos.Position(1),dsbpos.Position(2),dsbpos.Position(3),dsbpos.Position(4)];
    dsbut = uicontrol('Style','pushbutton','String','Del Seg','Units','normalized',...
        'Position',dsbposvec,'Callback',{@cb_delseg},'UserData',i);
    
    dispstat(sprintf('Segment %d out of %d built',i,length(segments)));
end

%Save all button
scrollsubplot(16,8,[41,48]+(8*(length(segments)-1)));
axis off
expos = scrollsubplot(16,8,[41,48]+(8*(length(segments)-1)));
exposvec = [expos.Position(1),expos.Position(2),expos.Position(3),expos.Position(4)];
exbut = uicontrol('Style','pushbutton','String','Save Segments','Units','normalized',...
        'Position',exposvec,'Callback',@cb_savesegs);


toc
fprintf('Debugging Environment Created in %.1f Seconds',toc);


            
   
    
%    function delname(i)
%        
%        segplot;   
%    end
%{    
    %Insname - Insert blankspace for name
    function insname(i)
        rtlist = {rtlist(1:i-1),' ',rtlist(i+1:end)};
        segplot;
    end

    %Delseg - Delete a bad segment
    function delseg(i)
        segments = [segments(1:i-1), segments(i+1:end)];
        limits = [limits(1:i-1,:), limits(i+1:end,:)];
        fullplot
        segplot
    end
    %}
    
    %playsound  
    
    
        %}

    %end
    %sound(segments{i}, fs);