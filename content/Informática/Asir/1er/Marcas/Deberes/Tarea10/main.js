/* 
Actualiza con el valor 'value' la etiqueta
con nombre 'name'
*/
function setValue(name,valor) {
    document.getElementsByName(name)[0].value = valor;
}
/* 
Devuelve el valor de la etiqueta con nombre 'name'
*/
function getValue(name) {
    return decodeURIComponent(window.location.search.replace(new RegExp("^(?:.*[&\\?]" + encodeURIComponent(name).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1")); 
}

function SaveStorage(key) {
    localStorage.setItem(key, getValue(key));
}