#Libraries
require 'rubygems'
require 'daemons'
require 'optparse'
require 'erb'
require 'activerecord'
require 'logger'
require 'grackle'
require 'time'
require 'thread'

# set the application root
APP_ROOT = File.join(File.dirname(__FILE__), "..")
DB_DIRECTORY = APP_ROOT
$:.unshift(File.join(APP_ROOT, "lib"))
DB_MUTEX = Mutex.new

#Application
require 'util'
require 'db'
require 'tweet'
require 'action'
require 'search'
require 'twobot'

