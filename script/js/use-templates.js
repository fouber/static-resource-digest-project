console.log('==============================');
console.log('= /script/js/use-template.js =');
console.log('==============================');
console.log('');

// use handlebars template

var tpl = __inline('/template/handlebars/foo.handlebars');
var data = {
    title: 'use handlebars',
    body: 'It works!'
};
var html = tpl(data);
console.log('use handlebars from js: ');
console.log(html);

// use ejs template

var tpl = __inline('/template/ejs/foo.ejs');
var data = {
    supplies: [ 'foo', 'bar' ]
}
var html = tpl(data);
console.log('');
console.log('use ejs from js: ');
console.log(html);

// use jade

var url = __uri('/html/jade/foo.jade');
var xhr = new XMLHttpRequest();
xhr.open('GET', url, false);
xhr.send();
console.log('');
console.log('use jade file:');
console.log(xhr.responseText);