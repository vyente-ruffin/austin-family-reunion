function onFormSubmit() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var row = sheet.getLastRow();
  
  // Insert the formula to calculate the total
  var formula = '=IF(OR(F' + row + '="", G' + row + '="", H' + row + '=""), "", VALUE(INDEX(SPLIT(F' + row + ', "$"), 1, 2)) + VALUE(INDEX(SPLIT(G' + row + ', "$"), 1, 2)) + VALUE(INDEX(SPLIT(H' + row + ', "$"), 1, 2)))';
  var totalCell = sheet.getRange(row, 13); // Assuming column M is column number 13
  totalCell.setFormula(formula);  
  
  // Format the Total cell as currency
  totalCell.setNumberFormat('$#,##0.00');
  
  // Allow some time for the formula to execute and the Total cell to update
  Utilities.sleep(5000);  // Pause for 5 seconds
  
  // Check if the Total cell has been populated
  var total = totalCell.getValue();
  if (total !== "") {
    // Get the last invoice number, increment it, and update the sheet
    var lastInvoiceNumber = sheet.getRange(row - 1, 14).getValue(); // Assuming column N is column number 14
    var nextInvoiceNumber = ("00000" + (parseInt(lastInvoiceNumber) + 1)).slice(-5);
    sheet.getRange(row, 14).setValue(nextInvoiceNumber); // Update the "Invoice Number" cell
    
    // Get the data from the corresponding cells
    var adults = sheet.getRange(row, 6).getValue();  // Assuming column F is column number 6
    var kids = sheet.getRange(row, 7).getValue();    // Assuming column G is column number 7
    var seniors = sheet.getRange(row, 8).getValue(); // Assuming column H is column number 8
    var respondentEmail = sheet.getRange(row, 2).getValue(); // Assuming the email address is in column B which is column number 2
    
    // Set the admin email address
    var adminEmail = "ruffin4it@gmail.com";

    // Define the CC email address here
    var ccEmail = "ruffin4it@gmail.com"; // Add your desired CC email address here

    // Get QR code images from Google Drive as inline attachments
    var zelleBlob = DriveApp.getFileById('16unhBgavSwOU-u_F_uhnzte4Dzh2D4x9').getBlob().setName('zelle');
    var cashAppBlob = DriveApp.getFileById('1N4PI5TLpEChwvhvyLMH51VhcRGf6Oevr').getBlob().setName('cashapp');
    
    // Create the HTML email body
    var emailBody = 
      "<p>Thank you for registering for the Austin Family Reunion in June 20, 2024. Your entry has been recorded. Please complete your registration by submitting your payment via Zelle or CashApp, then send a copy of your payment confirmation to austinreunion6@gmail.com. Below are your totals:</p>" +
      "<ul>" +
      "<li>Invoice Number: <b>" + nextInvoiceNumber + "</b></li>" +
      "<li>Adults Ages 13+: <b>" + adults + "</b></li>" +
      "<li>Kids Ages 4-12: <b>" + kids + "</b></li>" +
      "<li>Seniors Ages 65+: <b>" + seniors + "</b></li>" +
      "<li>Total: <b>$" + total + "</b></li>" +
      "</ul>" +
      "<p>Also, if you're able to add any extra info to Zelle or CashApp, please add your invoice number <b>" + nextInvoiceNumber + "</b> so we can match your transaction. Scan the QR code below to pay via Zelle:</p>" +
      "<img src='cid:zelle' alt='QR Code for Zelle Payment' />" +
      "<p>Or scan this QR code for CashApp payment:</p>" +
      "<img src='cid:cashapp' alt='QR Code for CashApp Payment' />";
    
    // Send the email to both the form respondent and the admin
    var subject = "Austin Family Reunion Registration Summary - Invoice Number: " + nextInvoiceNumber;
    GmailApp.sendEmail(respondentEmail + "," + adminEmail, subject, "", {
      htmlBody: emailBody, 
      cc: ccEmail,
      inlineImages: {zelle: zelleBlob, cashapp: cashAppBlob}
    });
  }
}
