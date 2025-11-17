// Batch_Substack_Slices.ijm
// -------------------------

// For each stack in an input folder:
//	- extracts one slice at a time
//	- saves each slice as a separate tiff in an output folder

// ------------- USER PARAMETERS ---------------
input_dir = getDirectory("Choose input folder with stacks");
// input_dir = "/Volumes/ROYAAB/Src_CA/WT/Sample18_Late/Processed/";

output_subfolder = "stacks/";

// File extension to process
ext = "tif";

start_slice = 1;
channels_spec = "1-3";
// ------------- END USER PARAMETERS ---------------

setBatchMode(true);

//ensure input_dir ends with "/"
if (!endsWith(input_dir, "/")) input_dir = input_dir + "/";

output_dir = input_dir + output_subfolder;

// Get all files in folder
list = getFileList(input_dir);

for (f = 0; f < list.length; f++) {
	name_lower = toLowercase(list[f]);
	if (!endWith(name_lower, "." + ext)) continue;

	filepath = input_dir + list[f];

	// get basename without extension
	basename = list[f];
	basename = replace (basename, ".tiff", "");
	basename = replace (basename, ".czi", "");

	// open once to get the number of slices
	open(filepath);
	getDimensions(width, height, channels, slices, frames);
	close();

	for (i = start_slice; i <= slices; i++) {
		open(filepath);
		run("Make Substack...", "channels=1-3 slices=" + i);

		out_path = output_dir + basename + "_slice" + i + ".tif";
		saveAs("Tiff", out_path);

		run("Close All");
	}
}

setBatchMode(false);
print("Done.");


