// Set the path to the folder containing the AE project files
var projectFolder = new Folder('/Users/HotBox/Library/Mobile Documents/com~apple~CloudDocs/LongBeachLive/Templates and Stingers');

// Get all the files in the project folder
var files = projectFolder.getFiles();

// Loop through each file and open it in After Effects
for (var i = 0; i < files.length; i++) {
  var file = files[i];
  
  // Check if the file is an AE project file
  if (file instanceof File && file.name.match(/\.aep$/i)) {
    // Open the AE project file
    var project = app.open(file);
  
  // Parent text layers to their respective object layers
  var textLayers = ["MainText", "SubText"]; // Replace with your own text layer names
  var objectLayers = ["Box 5", "Box 2"]; // Replace with your own object layer names
  
  for (var j = 0; j < textLayers.length; j++) {
    var textLayer = comp.layer(textLayers[j]);
    var objectLayer = comp.layer(objectLayers[j]);
  
    textLayer.parent = objectLayer;
  }

// Loop through each pair of layers and adjust their properties
for (var i = 0; i < textLayers.length; i++) {
  var textLayer = app.project.activeItem.layer(textLayers[i]);
  var objectLayer = app.project.activeItem.layer(objectLayers[i]);
  
  // Get the position and scale of the object layer
  var objPosition = objectLayer.transform.position;
  var objScale = objectLayer.transform.scale;
  
  // Adjust the anchor point of the text layer to match the object layer
  textLayer.transform.anchorPoint.setValue([objPosition[0], objPosition[1]]);
  
  // Scale the text layer based on the object layer scale
  var textScale = textLayer.transform.scale;
  textLayer.transform.scale.setValue([objScale[0] * textScale[0], objScale[1] * textScale[1]]);
  
  // Adjust the x-axis position of the text layer based on the object layer position and scale
  var textPosition = textLayer.transform.position;
  textLayer.transform.position.setValue([objPosition[0] + objScale[0] * textPosition[0], objPosition[1] + objScale[1] * textPosition[1]]);
}

  // Modify the composition as needed
 // comp.workAreaDuration = comp.duration;
  
  // Render the composition
  var renderQueue = app.project.renderQueue;
  var render = renderQueue.items.add(comp);
  render.outputModule(1).file = outputFile;
  renderQueue.render();
  
  app.project.save();
  app.project.close
}
}
