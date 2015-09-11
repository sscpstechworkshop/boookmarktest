function alphabetizeSheets(){
  // Browser.msgBox("Inside alphabetizeSheets function.  Please click OK.");
  // this function will put sheet "Start" first, then "Weekly Summary". Then put
  // "TemplateStudent" last.  And lastly alphabetize the remaining at position 3.
  var totalNumberSheets = SpreadsheetApp.getActiveSpreadsheet().getNumSheets();
  var sourceSpreadsheet = SpreadsheetApp.getActiveSpreadsheet();

  // put Start, Weekly Report, & TemplateStudent Sheets in proper position
  var sheet = sourceSpreadsheet.getSheetByName("Start");
  sourceSpreadsheet.setActiveSheet(sheet);
  sourceSpreadsheet.moveActiveSheet(1);
  var sheet = sourceSpreadsheet.getSheetByName("Weekly Summary");
  sourceSpreadsheet.setActiveSheet(sheet);
  sourceSpreadsheet.moveActiveSheet(2);
  var sheet = sourceSpreadsheet.getSheetByName("TemplateStudent");
  sourceSpreadsheet.setActiveSheet(sheet);
  sourceSpreadsheet.moveActiveSheet(totalNumberSheets);

  // create array of sheet names, and removing default sheets
  var sheetsNameArray = SpreadsheetApp.getActiveSpreadsheet().getSheets();
  var sheetsNameArraySorted = new Array();
  for (i in sheetsNameArray) {
    if (["Start", "Weekly Summary", "TemplateStudent"].indexOf(sheetsNameArray[i].getName()) == -1) {
      sheetsNameArraySorted.push(sheetsNameArray[i].getName());
    }
  }
  //sheetsNameArraySorted.sort();
  sheetsNameArraySorted.sort(function (a, b) {
    return a.toLowerCase().localeCompare(b.toLowerCase());
    });

  // now move the sheets around
  var newIndexCounter = 3;
  for (i in sheetsNameArraySorted) {
    var sheet = sourceSpreadsheet.getSheetByName(sheetsNameArraySorted[i]);
    sourceSpreadsheet.setActiveSheet(sheet);
    sourceSpreadsheet.moveActiveSheet(newIndexCounter);
    newIndexCounter = newIndexCounter + 1;
  }
  // put back to Start sheet for next action
  var sheet = sourceSpreadsheet.getSheetByName("Start");
  sourceSpreadsheet.setActiveSheet(sheet);
}
