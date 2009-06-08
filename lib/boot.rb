#Libraries
require 'rubygems'
require 'optparse'
require 'erb'
require 'activerecord'
require 'logger'
require 'grackle'
require 'time'

# set the application root
APP_ROOT = File.join(File.dirname($0), "..")
$:.unshift(File.join(APP_ROOT, "lib"))

#Application
require 'util'
require 'db'
require 'tweet'
require 'action'
require 'search'
require 'twobot'

