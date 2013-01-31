"use strict"

Crawler = require("crawler").Crawler
_ = require 'underscore'
fs = require 'fs'
wget = require 'wget'

tianya = {}
get_tianya_user_home = (id) ->
  "http://www.tianya.cn/#{id}"
get_tianya_user_logo = (id) ->
  "http://tx.tianyaui.com/logo/#{id}"
get_tianya_user_id = (url) ->
  idx = url.lastIndexOf '/'
  return off if idx == -1
  url.substr idx+1

page_parse = ($) ->
  $('img').each ->
    name = $(@).attr('alt')
    return off unless name
    id = get_tianya_user_id $(@).attr('src')
    return off unless id
    logo = get_tianya_user_logo id
    tianya[id] =
      id: id
      name: name
      logo: logo
    img = wget.download logo, "logo/#{id}.jpg"
    img.on 'error', (err) ->
      console.log err

next_page_parse = ($) ->
  $('img').each ->
    name = $(@).attr('alt')
    return off unless name
    id = get_tianya_user_id $(@).attr('src')
    return off unless id
    c.queue get_tianya_user_home id
  off

tianya_page_cb = (error, result, $) ->
  page_parse $
  return if _.size(tianya) > 50000
  next_page_parse $

job_end = ->
  for id, u of tianya
    console.log "#{u.id} #{u.name}"
  off

c = new Crawler
  maxConnections: 2
  callback: tianya_page_cb
  onDrain: job_end

c.queue "http://www.tianya.cn/26520815"
