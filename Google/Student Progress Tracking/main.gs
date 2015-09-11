/*

TO DO:
  * createWeeklySummary process - figure out how to determine "Monday" for both this week and last week
  * figure out how to get array of all student sheets via separate function, update alphabetizeSheets()
  * createWeeklySummary process - copy all rows from student sheets based on "Monday"
  * createWeeklySummary process - do one warning if sheets exist without update
  * do checkup on all students sheets if "Week of" column is not a Monday (when to do?)
  * createWeeklySummary process - do charts for grades change & homework done
  * createStudentSummary process - add sheet & add it to alphabetizeSheets()
  * createStudentSummary process - ask "Enter student name or leave blank for all"
  * createStudentSummary process - put student name at top & charts for all grade & homework done
  * createStudentSummary process - copy in all "Comments / Observations" & "Actions / Directives"
  * createStudentSummary process - check if can force new page after student & automatically bring up print

*/


function createWeeklySummary() {
  var startSummaryLastWeek = Browser.msgBox('Summary based on last week?', Browser.Buttons.YES_NO)
  Browser.msgBox('Answer: ' + startSummaryLastWeek + '. Functionality in future release.')
}


function createNewStudent() {
  // Browser.msgBox("Inside createNewStudent function.  Please click OK.");
  // this function will:
  //    01. ask for the name of the new student
  //    02. check if that sheet already exists, if yes, tell user
  //    03. if sheet with name does not exist, copy the "TemplateStudent"
  //        sheet to a new sheet of that name.
  // Display a dialog box with a message and "Yes" and "No" buttons.
  var newStudentName = Browser.inputBox('Create New Sheet', 'What is the name of the student?', Browser.Buttons.OK_CANCEL);
  if (newStudentName != "") {
    //Browser.msgBox(newStudentName);
    // The code below will log the index of a sheet named "Expenses"
    var newSheetExist = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(newStudentName);
    if (newSheetExist != null) {
      Browser.msgBox("Sheet with name of  " + String.fromCharCode(34) + newStudentName + String.fromCharCode(34) + " already exists.");;
    } else {
      // Browser.msgBox("Sheet with name of  " + String.fromCharCode(34) + newStudentName + String.fromCharCode(34) + " does not exist.");;
      var sourceSpreadsheet = SpreadsheetApp.getActiveSpreadsheet();
      var sourceSpreadsheetID = sourceSpreadsheet.getId();
      var sourceSheet = sourceSpreadsheet.getSheetByName("TemplateStudent");
      //var destinationSpreadsheet = SpreadsheetApp.openById(sourceSpreadsheetID);
      sourceSheet.copyTo(sourceSpreadsheet);
      var newSheet = sourceSpreadsheet.getSheetByName("Copy of TemplateStudent");
      newSheet.setName(newStudentName);
      alphabetizeSheets();
    }
  }
  // check if go back to Start sheet
  if (Browser.msgBox('Stay on new sheet for ' + newStudentName + '?', Browser.Buttons.YES_NO) == 'yes') {
    var sheet = sourceSpreadsheet.getSheetByName(newStudentName);
    sourceSpreadsheet.setActiveSheet(sheet);
  }
}
