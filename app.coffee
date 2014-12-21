# svmed уебаны криворукие http://dl2.joxi.net/drive/0000/1763/1763/141209/23b61758ef.png

# */5 * * * * cd /Users/roma/work/fuck-you-svmed && /usr/local/bin/node app.js >>/tmp/fuck-you-svmed.log 2>&1
# coffee -o . -wc app.coffee

cheerio  = require('cheerio')
request  = require('request')
Twit     = require('twit')
readJSON = require('read-json')

readJSON './credentials.json', (err, credentials) ->

  T = new Twit(
    consumer_key: credentials.consumer_key
    consumer_secret: credentials.consumer_secret
    access_token: credentials.access_token
    access_token_secret: credentials.access_token_secret
  )

  message =  """
    yo @milushov, ur tickets found!

    (message from bot -- http://goo.gl/z6bu1M)
  """

  url = 'http://94.19.37.202:3069/cgi-bin/tcgi1.exe'
  form = {
    USER: null
    COMMAND:3000
    PASSWORD:46
    NAMESHOWFILE: null
  }

  request.post url: url, form: form, (error, response, body) ->
    found = no
    $ = cheerio.load(body)

    $('td').each (i, el) ->
      td = $(el)

      if td.text() is '������������'
        id = td.prev().prev().text()

        if id is '15' || id is '16'
          return if found

          tickets_count = td.next().next().text()
          console.info("tickets count on #{new Date} --- ", tickets_count)

          if parseInt(tickets_count) > 0
            found = yes
            console.info('yay!')
            T.post 'statuses/update', status: message, ->

