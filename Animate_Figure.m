function [figHandle] = Animate_Figure(fileName,movieName,playBackRate,frameInc,duration,video_label)
% INPUTS  
% fileName - name of file (e.g. 'Run_Forced_Rotation_EMG.csv')
% movieName - name of movie file of interest (e.g. 'Run_Forced_Rotation.mp4')
% playBackRate - playback delay time for GIF file (usually set this to 0.005)
% frameInc - increment to sample movie frames at; e.g. normal video is at 
%            30 fps and if you film 30 fps and want to see each frame then 
%            set to 1, if filmed at a higher rate or want to make the gif
%            accelerated you may want to increasing the frameInc above 1.
% duration - length in seconds of data you want shown in the GIF (e.g. 10
%            will produce a GIF of the first 10s of data), must be equal to
%            or less than the shorter of the data and movie file
% video_label - a string containing the label or title of the video trial
%            (e.g. 'Forced Rotation')

%% Load data
current_path = pwd;
Data = readtable([current_path, filesep, 'data', filesep, fileName]);
D_hz = 1/(Data.time(2)-Data.time(1)); % sample frequency of data in Hz

% Load in video
movieObj = VideoReader([current_path, filesep, 'data', filesep, movieName]);
nFrames = movieObj.NumFrames;
M_hz= movieObj.FrameRate; % frame rate of movie in fps or Hz
sampleRatio = D_hz/M_hz;

% Get corresponding times (both starting from zero)
t_dat = Data.time - Data.time(1); % time vector for data

% Determine y-axes bounds
y_bounds = nan(size(Data,2),2);
for i = 2:size(Data,2)
    y_bounds(i,:) = Find_y_bounds(Data{:,i}); % reported as [min, max]
end

%% Start creating the new movie synched with data:

% Some basic video information
vidHeight = movieObj.Height;
vidWidth = movieObj.Width;

% Font specifications for the graph
fontSpecs = {'FontName','Arial','FontSize', 14,'FontWeight', 'bold'};

%%
% Preallocate movie structure: here we are saving only one frame in memory
% at a time, so mov structure has size 1, to minimize memory load
mov(1) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);

%%
% Read movie a single frame at a time, incrementing through the 
% specified time endIDx in increments of 'frameInc'. 
figHandle = [];
frameIdx = 1:frameInc:(duration*M_hz); % index of movie frames of interest (use 1:frameInc:movieObj.NumFrames for all frames)

for m = 1:length(frameIdx) % m = 1:length(frameIdx) % FOR FULL TRACES & VIDEO

    k = frameIdx(m); 
    currentPt_Idx = round(k*sampleRatio); % index for data corresponding to specific movie frame 

if currentPt_Idx <= size(Data,1) % only want to create figure if we have enough data
%% Create figure
figHandle = figure;
% Size the figure based on the video's width and height,
% size: [left, bottom, width, height]
set(figHandle, 'units', 'normalized')
set(figHandle, 'position', [0 0 1 1]) % sets figure to entire window size
set(figHandle,'Color',[0.92 0.92 0.92]);

movAx1 = subplot('position', [0, 0.70, 1, 0.30]); % [left,bottom,%-width,%-hight]
    hold on;
    set(movAx1,'XTick',[],'YTick', []);
    box off;
ah12 = subplot('position',[0.05 0.5166 .90 .1833]);
    hold on;
    box off;
    set(ah12,'Color','none');
    xlim([0,duration])
    ylim([min([y_bounds(2,1),y_bounds(5,1)]), max([y_bounds(2,2),y_bounds(5,2)])])
    ylabel('LG Activity (V)',fontSpecs{:},'Color',[0,0,0]);
ah13 = subplot('position',[0.05 0.2833 .90 .1833]);
    hold on;
    box off;
    set(ah13,'Color','none');
    xlim([0,duration])
    ylim([min([y_bounds(3,1),y_bounds(6,1)]), max([y_bounds(3,2),y_bounds(6,2)])])
    ylabel('MG Activity (V)',fontSpecs{:},'Color',[0,0,0]);
ah14 = subplot('position',[0.05 .05 .90 .1833]);
    hold on;
    box off;
    set(ah14,'Color','none');
    xlim([0,duration])
    ylim([min([y_bounds(4,1),y_bounds(7,1)]), max([y_bounds(4,2),y_bounds(7,2)])])
    xlabel ('time (s)',fontSpecs{:});
    ylabel('RF Activity (V)',fontSpecs{:},'Color',[0,0,0]);
        
set(gcf,'color','w'); %sets background color of whole figure to white

%% read Movie frame
movieObj.CurrentTime = ((k-1)./movieObj.FrameRate); %possibly round
mov.cdata = readFrame(movieObj);
    mov.colormap = [];    
    [imdat,cmap]=frame2im(mov);
    
    % Flip movie around
    for zi = 1:size(imdat,3)
        imdat(:,:,zi)=flipud(imdat(:,:,zi));
        %imdat(:,:,zi)=fliplr(imdat(:,:,zi));
    end
    
%% Plot data
    % Plot the movie image (see imageplot below)
%axes(movAx1); 
set(figHandle,'CurrentAxes',movAx1);
    imageplot(imdat,figHandle,cmap);
    hold on;
    text(30,1020,video_label,'FontSize',16,'FontName','Arial','FontWeight','bold','Color',[1,1,1]);

n_dat = round((frameInc*sampleRatio*m)-(frameInc*sampleRatio-1));

%axes(ah12);
set(figHandle,'CurrentAxes',ah12);
plot(t_dat,Data.L_LG,'Color',[1,0.6,0.6],'LineWidth',1.5); % plot faint line of entire duration (left leg)
hold on;
plot(t_dat(1:n_dat),Data.L_LG(1:n_dat),'r','LineWidth',2); % plot current line up to frame of interest (left leg)
plot(t_dat,Data.R_LG,'Color',[0.6,0.6,1],'LineWidth',1.5); % plot faint line of entire duration (right leg)
plot(t_dat(1:n_dat),Data.R_LG(1:n_dat),'b','LineWidth',2); % plot current line up to frame of interest (right leg)
%axes(ah13)
set(figHandle,'CurrentAxes',ah13);
plot(t_dat,Data.L_MG,'Color',[1,0.6,0.6],'LineWidth',1.5); % plot faint line of entire duration (left leg)
hold on;
plot(t_dat(1:n_dat),Data.L_MG(1:n_dat),'r','LineWidth',2); % plot current line up to frame of interest (left leg)
plot(t_dat,Data.R_MG,'Color',[0.6,0.6,1],'LineWidth',1.5); % plot faint line of entire duration (right leg)
plot(t_dat(1:n_dat),Data.R_MG(1:n_dat),'b','LineWidth',2); % plot current line up to frame of interest (right leg)
%axes(ah14)
set(figHandle,'CurrentAxes',ah14);
plot(t_dat,Data.L_RF,'Color',[1,0.6,0.6],'LineWidth',1.5); % plot faint line of entire duration (left leg)
hold on;
plot(t_dat(1:n_dat),Data.L_RF(1:n_dat),'r','LineWidth',2); % plot current line up to frame of interest (left leg)
plot(t_dat,Data.R_RF,'Color',[0.6,0.6,1],'LineWidth',1.5); % plot faint line of entire duration (right leg)
plot(t_dat(1:n_dat),Data.R_RF(1:n_dat),'b','LineWidth',2); % plot current line up to frame of interest (right leg)

drawnow; 

%   Make movie frame out of current figure
    currFrame = getframe(figHandle);
    im = frame2im(currFrame);
%    Write to video file
%    writeVideo(synchedMovie,currFrame);   
    [imind,cm] = rgb2ind(im,256);
    
    save_name = [current_path, filesep, 'results', filesep, movieName(1:end-4) '.gif'];
    if k == 1 % use k == 1 % FOR FULL TRACES & VIDEO
        imwrite(imind,cm,save_name,'gif','Loopcount',inf,'DelayTime', playBackRate)
    else
        imwrite(imind,cm,save_name,'gif','DelayTime', playBackRate,'WriteMode','append')
    end
  
    if k < (nFrames - frameInc)
        close(figHandle);
        figHandle = [];
    end
end
end

% %% Close the video file for the new movie
% close(synchedMovie);

end

%% FUNCTIONS
function y_bound = Find_y_bounds(y)
% This function determines the minimum and maximum values for the vector y
% so that when it is plotted it displays [y_min, y_max] where y_min and
% y_max are 5% beyond the actualy minima and maxima values of y.

% INPUTS
% y - numerical vector containing data interested in visualizing

% OUTPUTS
% y_bound - the y-axis bounds for y that give a 5% buffer on either end
%           [y_min_bound, y_max_bound]

delta_y = max(y)-min(y);
y_max_bound = max(y)+0.05*delta_y;
y_min_bound = min(y)-0.05*delta_y;

y_bound = [y_min_bound, y_max_bound];
end

function [im] = imageplot(imdat,dfh,cmap)
% Function to plot image frames from movie files

% INPUTS
% imdat - image data from frame of interest
% dfh - figure handle
% cmap - colormap for image

% OUTPUTS
% im - is the image object (function plots the image if it exists)

if ~exist('imdat','var')
    warning('No image data')
end

if ~exist('dfh','var')
    dfh = gcf;
elseif isempty(dfh)
    dfh = gcf;
end

if ~exist('cmap','var')
    cmap=[];
elseif isempty(cmap)
    cmap = [];
end

figure(dfh);
if ~isempty(cmap)
    im=image(imdat,'CDataMapping','scaled');
    colormap(cmap)
else
    im=image(imdat);
end

% set(han,'EraseMode','normal');
axis xy
axis image
hold on

end