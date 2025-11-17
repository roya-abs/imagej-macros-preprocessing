// Batch_Crop_with_ROI.ijm

// ------------------------
// For each image in an input folder:
//	- apply a ROI loaded into ROI Manager
//	- crop to that ROI
//	- save images

// -------------- USER PARAMETERS ----------------

input_dir = getDirectory("Choose input folder with stacks");
// input_dir = "/Volumes/ROYAAB/Src_CA/WT/Sample18_Late/Processed/Stacks";

roi_path = File.openDialog("Choose ROI or ROI set (.roi or .zip)");

output_subfolder = "cropped/";

input_ext = "tif";

output_format = "Jpeg";
output_ext = ".jpg";

roi_index = 0;

//-------------- END USER PARAMETERS ----------------

setBatchMode(true);

// ensure inputDir ends with "/"
if (!endsWith(input_dir, "/"))
    inputDir = input_dir + "/";

output_dir = input_dir + output_subfolder;

// load ROI(s) into ROI Manager once
run("ROI Manager...");
roiManager("Reset");
roiManager("Open", roi_path);

for (i = 0; i < list.length; i++) {
    nameLower = toLowerCase(list[i]);
    // Skip non-matching extensions
    if (!endsWith(nameLower, "." + input_ext))
        continue;

    filepath = input_dir + list[i];

    // Get basename (without common extensions)
    basename = list[i];
    basename = replace(basename, ".tif", "");

    // Open image
    open(filepath);

    // Apply ROI and crop
    roiManager("Select", roiIndex);
    run("Crop");  // creates a new cropped image and makes it active

    // Build output path and save
    out_path = output_dir + basename + "_cropped" + output_ext;
    saveAs(output_format, out_path);

    // Close cropped + original images (ROI Manager stays open)
    run("Close All");
}

setBatchMode(false);
print("Batch cropping done.");
