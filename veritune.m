function [outputVector] = veritune(inputVector, st)
clc
%scaling
S = 2^15 - 1;

step = 2*st;

%pitch scaling factor
alpha = 2*step;

%space between windows, they have as 256
hop = 256;

hopOut = round(alpha*hop);

x = inputVector;

windowSize = 1024;

% Hanning window for overlap-add
wn = hann(windowSize*2+1);
wn = wn(2:2:end); 


%---------------------First part: creating frams----------------------------------------
%outputs vectorFrames and num_slices

%Max number of slices that can be obtained: Rounded! (length of input -
%window size) / hop

num_slices = floor((length(x) - windowSize) / hop);

% local changing of the source file to truncate and make sure only integer # of hop
x = x(1:(((num_slices*hop)) + windowSize));

% Get vectorFrames
for index = 1:num_slices

    indexTimeStart = (index-1)*hop + 1;
    indexTimeEnd = (index-1)*hop + windowSize;

    vectorFrames(index,:) = x(indexTimeStart: indexTimeEnd);

end 

for index=1:num_slices
%ANALYSIS
%get current frame
currentFrame = vectorFrames(index,:);

%window the frame!
currentFrameWindowed = currentFrame .* wn' / sqrt(((windowSize/hop)/2));

%fft
currentFrameWindowedFFT = fft(currentFrameWindowed);

%get magnitude
magFrame = abs(currentFrameWindowedFFT);

outputFrame = real(ifft(magFrame))*5;

outputy(index,:) = outputFrame .* wn' / sqrt((windowSize/hopOut)/2);

end


%FINALIZE
	
%--------------------Second part: fusing the frames together------------------------------
%inputs: frameMatrix, has all of the frames
%		  hop
%outputs: vectorTime:vector from adding frames

sizeMatrix = size(outputy);

% Get number of frames
num_frames = sizeMatrix(1);

% Get size of each frame
size_frames = sizeMatrix(2);

% init
timeIndex = 1;
vectorTime = zeros(num_frames*hopOut-hopOut+size_frames,1);

% Loop for every fram and operlap-add
for index=1:num_frames - 1
    [index timeIndex timeIndex+size_frames-1 size(vectorTime)]
    vectorTime(timeIndex:timeIndex+size_frames-1) = vectorTime(timeIndex:timeIndex+size_frames-1) + outputy(index,:)';

    timeIndex = timeIndex + hopOut;

end
outputVector = vectorTime;
%for k=1:step:(length(vectorTime) - 1)
%    [k length(vectorTime)]
%    outputVector = outputy(k,:);
%end


return
