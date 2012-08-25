# update the path for the requires
$: << '.'

require 'rubygems'
require 'gosu'

require 'MyWindow'
require 'Skull'
require 'Heart'
require 'Princess'
require 'Ludumi'

window = MyWindow.new
window.show