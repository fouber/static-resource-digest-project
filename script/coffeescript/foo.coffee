# @see http://coffeescript.org/

# Assignment:
number   = 42
opposite = true

# Conditions:
number = -42 if opposite

# Functions:
square = (x) -> x * x

# Arrays:
list = [1, 2, 3, 4, 5]

# Objects:
math =
  root:   Math.sqrt
  square: square
  cube:   (x) -> x * square x

# Splats:
race = (winner, runners...) ->
  print winner, runners

# Existence:
alert "I knew it!" if elvis?

# Array comprehensions:
cubes = (math.cube num for num in list)

console.log ''
console.log '============================='
console.log '= /script/coffee/foo.coffee ='
console.log '============================='
console.log ''

console.log cubes

# resource location
console.log ''
console.log 'locate resource in coffee:', __uri 'coffee.png'

# use handlebars

tpl = __inline '/template/handlebars/foo.handlebars'
data =
    title: 'coffee use handlebars'
    body: 'It works!'
html = tpl data
console.log ''
console.log 'use handlebars from coffee: '
console.log html

# use ejs

tpl = __inline '/template/ejs/foo.ejs'
data =
    supplies: [ 'in coffee', 'EJS works!' ]
html = tpl data
console.log ''
console.log 'use handlebars from coffee: '
console.log html