$(function () {
  $("input:file").change(function (){
    var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv|.txt)$/;
    if (regex.test($("#import_request_import_file").val().toLowerCase())) {
      if (typeof (FileReader) != "undefined") {
        var reader = new FileReader();
        reader.onload = function (e) {
          var data = [];
          var table = $("<table />");
          var rows = e.target.result.split("\n");
          for (var i = 0; i < rows.length; i++) {
            var row = $("<tr />");
            var cells = rows[i].split(",");
            
            data.push(cells);
            for (var j = 0; j < cells.length; j++) {
              var cell = $("<td />");
              cell.html(cells[j]);
              row.append(cell);
            }
            table.append(row);
          }

          container = document.getElementById('import_file_rows'),
          $("#import_file_rows").html("")
          hot = new Handsontable(container, {
            data: data,
            minSpareRows: 1,
            colHeaders: true,
            contextMenu: true
          });

          $("#dvCSV").html('');
          $("#dvCSV").append(table);
        }
        reader.readAsText($("#import_request_import_file")[0].files[0]);


      } else {
        alert("This browser does not support HTML5.");
      }
    } else {
        alert("Please upload a valid CSV file.");
    }
  });
});