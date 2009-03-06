// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function trim(text)
{
	while(text.value.charAt(0)==' ')
		text.value=text.value.substring(1,text.value.length )
	
	while(text.value.charAt(text.value.length-1)==' ')
		text.value=text.value.substring(0,text.value.length-1)
}