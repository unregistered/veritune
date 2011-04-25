
//---------------------First part: creating frams----------------------------------------
//outputs vectorFrames and num_slices



// Max number of slices that can be obtained: Rounded! (length of input - window size) / hop
num_slices <= 

// space between windows, they have as 256
hop <= 

// local changing of the source file to truncate and make sure only integer # of hop
x <= 

// Size of the windows, they have as 1024
windowSize <=

// Get vectorFrames
for (i = 0; i < num_slices + 1; i = i+1) 
	begin
		iTimeStart <= (i - 1) * hop + 1;
		iTimeEnd <= (i - 1) * hop + windowSize;
	
		vectorFrames[i,:] <= x[iTimeStart,iTimeEnd];
	end
	
	
//--------------------Second part: fusing the frames together------------------------------
//inputs: frameMatrix, has all of the frames
//		  hop
//outputs: vectorTime:vector from adding frames

// Get number of frames
num_frames <= 

// Get size of each frame
size_frames <=

//init
timeIndex <= 1;

// Loop for every fram and operlap-add
for (j = 0; j < num_frames; j = j+1)
	begin
		vectorTime[timeIndex:timeIndex + size_frames - 1] <= vectorTime[timeIndex:timeIndex + size_frames - 1] + frameMatrix[index,:];
		
		timeIndex = timeIndex + hop;
	end
	