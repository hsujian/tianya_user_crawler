"use strict"

Crawler = require("crawler").Crawler
_ = require 'underscore'
fs = require 'fs'
wget = require 'wget'

tianya = {}
get_tianya_user_logo = (id) ->
  "http://tx.tianyaui.com/logo/#{id}"
get_tianya_user_id = (url) ->
  url.substr 21

page_parse = ($) ->
  $('a.author').each ->
    name = $(@).text()
    id = get_tianya_user_id $(@).attr('href')
    logo = get_tianya_user_logo id
    tianya[id] =
      id: id
      name: name
      logo: logo
    wget.download logo, "logo/#{id}.jpg"

tianya_page_cb = (error, result, $) ->
  page_parse $

  return if _.size(tianya) > 10000

  $('.short-pages-2.clearfix .links a').each (idx, a) ->
    if a.innerHTML == '下一页'
      c.queue a.href
  off

job_end = ->
  for id, u of tianya
    console.log "#{u.id} #{u.name}"
  off

c = new Crawler
  maxConnections: 2
  callback: tianya_page_cb
  onDrain: job_end

c.queue "http://bbs.tianya.cn/list-funinfo-1.shtml"
