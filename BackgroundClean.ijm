dir1 = getDirectory("Choose input MRI Images Directory ");   
list = getFileList(dir1);                                    // gives ImageJ a list of all files in the folder to work through
print("number of files in dir1 Segments",list.length); 

dir2 = getDirectory("Choose Output Image Directory ")


listerrs=0;
for (f=0; f<list.length; f++) {

	imageID = substring( list[f], 0,10);
	print ("imageID",imageID);


    path = dir1+list[f];                       // creates the filepath for reading Segmentation files
	print("Name of path reading file from dir1",path); 

     showProgress(f, list.length);     // optional progress monitor displayed at top of Fiji
      if (!endsWith(path,"/")) open(path);  // if subdirectory, push down into it Still have to open Path
        
	   t=getTitle();    // gets the name of the image being processed   

		print("getTitle got t=", t ); 
		
		tt = substring(t,0,15); // Shortens title from start to X characters (t,0,X)
		run("Duplicate...");
		rename(imageID+ "TissueMask.tif");
		call("ij.plugin.frame.ThresholdAdjuster.setMode", "B&W");
		setThreshold(4507, 65535);
		run("Convert to Mask", "method=Default background=Dark calculate black");
		run("Fill Holes");
		run("Divide...", "value=255 stack");
		imageCalculator("Multiply create stack", t,imageID+"TissueMask.tif");
		selectWindow("Result of "+t);
		saveAs("Tiff",dir2+t+"background.tif");
		run("Close All");
}