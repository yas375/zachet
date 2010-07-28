// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function add_fields(link, association, content) {  
    var new_id = new Date().getTime();  
    var regexp = new RegExp("new_" + association, "g");  
    $(link).before(content.replace(regexp, new_id));  
}
// TODO refactor next two functions in one function
function remove_job(link) {
  var container = $(link).parents(".job").hide();
  $("input[type=hidden]", container).val("1");
}

function remove_photo(link) {
  var container = $(link).parents(".photo").hide();
  $("input[type=hidden]", container).val("1");
}
$(function() {
  $('select.comboselect').livequery(function(){
    $(this).comboselect({
      sort: 'both',
      addbtn: ' > ',
      rembtn: ' < '
    });
  });
});

