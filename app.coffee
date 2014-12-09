# svmed -- пидоры и выблядки, как я вас ненавижу
# уебаны криворукие http://dl2.joxi.net/drive/0000/1763/1763/141209/23b61758ef.png

cheerio = require('cheerio')
request = require('request')
Twit    = require("twit")

T = new Twit(
  consumer_key: process.env.consumer_key
  consumer_secret: process.env.consumer_secret
  access_token: process.env.access_token
  access_token_secret: process.env.access_token_secret
)

url = 'http://94.19.37.202:3069/cgi-bin/tcgi1.exe'
form = {
  USER: null
  COMMAND:3000
  PASSWORD:46
  NAMESHOWFILE: null
}

request.post url: url, form: form, (error, response, body) ->
  founded = no
  $ = cheerio.load(body)

  $('td').each (i, el) ->
    td = $(el)
    if td.text() is '������������' # НЕВРОПАТОЛОГ on windows1251
      id = td.prev().prev().text()
      if id is '15' || id is '16'
        tickets_count = td.next().next().text()
        console.info("tickets count on #{new Date} --- ", tickets_count)
        if parseInt(tickets_count) >= 0
          console.info('yay!')

          T.post 'statuses/update',
            status: 'hello world!'
          , (err, data, response) ->
            console.log data




