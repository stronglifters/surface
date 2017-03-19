# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require clipboard
#= require lodash
#= require moment
#= require jquery
#= require jquery_ujs
#= require backbone
#= require Chart.bundle
#= require chartkick
#= require fullcalendar
#= require vue

#= require_self
#= require_tree .
#= require turbolinks

window.Stronglifters ?= {}

document.addEventListener "turbolinks:load", () =>
  new Stronglifters.Startup().start()

$(document).ready () =>
  Stronglifters.Behaviour.install()
  for event in [ "before-cache", "before-render", "before-visit", "click", "load", "render", "request-end", "request-start", "visit" ]
    $(document).on "turbolinks:#{event}", =>
      console.log "Triggered: #{event}"
