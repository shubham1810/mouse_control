%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	PROGRAM : Virtual Mouse controller											%%
%%	AUTHOR  : Shubham Dokania												%%
%%	DETAILS : Control your PC's mouse throught the position of your fingers which will be covered in coloured tape.		%%
%%		  The program works through the tracking of the colored components and adjusting the PC mouse according to it.  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


vid=videoinput('winvideo',1);
triggerconfig(vid,'manual');
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
start(vid);
jRobot = java.awt.Robot;
screen = get(0,'ScreenSize');
redThresh = 0.10 ;
blueThresh = 0.10;
for i=1:500
    trigger(vid);
    im=getdata(vid,1);
    k = size(im);
    im = flip(im,2);
    im2 = imsubtract(im(:,:,3), rgb2gray(im));
    im3 = imsubtract(im(:,:,2), rgb2gray(im));
    im2 = im2bw(im2, redThresh);
    im3 = im2bw(im3, blueThresh);
    im2 = xor(bwareaopen(im2, 1500), bwareaopen(im2,6700));
    im3 = xor(bwareaopen(im3, 2000), bwareaopen(im3,10000));
    stats = regionprops(im2);
    statsBlue = regionprops(im3);
    szBlue = size(statsBlue);
    sz = size(stats);
    imshow(im);
    if(szBlue(1)==2)
        r=rectangle('Position', statsBlue(1).BoundingBox);
        set(r, 'EdgeColor','b');
        tr=rectangle('Position', statsBlue(2).BoundingBox);
        set(tr, 'EdgeColor','b');
        %jRobot.mousePress(4);     %%%%%%%%%%%%%%%%%%%%%%%%%% THIS PART CONTROLS CLICKING %%%%%%%%%%%%%%%%%%%%%
        %pause(0.1);
        %jRobot.mouseRelease(4);
    else
        %jRobot.mouseRelease(4);
    end;
    if(sz(1)>0 && sz(1)<2)
        r = rectangle('Position', stats.BoundingBox);
        set(r, 'EdgeColor','r');
        line(stats.Centroid(1),stats.Centroid(2), 'Marker', '*', 'MarkerEdgeColor', 'g');
        jRobot.mouseMove(stats.Centroid(1),stats.Centroid(2));
        line(k(2)/2,k(1)/2, 'Marker', '*', 'MarkerEdgeColor', 'r');
        m = (stats.Centroid(1)-k(1))/(stats.Centroid(2)-k(2));
        theta = atand(m);
        alpha = abs(90-theta);
        alpha
    end;
        
    if(szBlue(1)==1)
        r=rectangle('Position', statsBlue.BoundingBox);
        set(r, 'EdgeColor','b');
        %jRobot.mousePress(16);
    else
        pause(0.2);
        %jRobot.mouseRelease(16);
            
    end;
    
    
        
end
stop(vid);
delete(vid);
clear vid;

% DO NOT MESS WITH THE CODE%
