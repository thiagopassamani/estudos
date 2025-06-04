$(document).ready(function(){
  $("#search-table").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#monitoring-table tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});