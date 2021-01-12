# From CryptoCurrency. Add or remove. 40+ supportet coins, check here: https://www.cryptocompare.com/api/data/coinlist/
cryptos_to_watch = ['BTC', 'ETH']
currency = 'EUR'

req = cryptos_to_watch.join(",")
command: "curl -s 'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{req}&tsyms=#{currency}'"

refreshFrequency: 300000

style: """
  top:10px
  left: 10px
  color: #fff
  font-family: Helvetica Neue
  border-radius: 10px
  background-color: rgba(0,0,0,0.5)

  table
    border-collapse: collapsec
    table-layout: fixed
    -webkit-font-smoothing: antialiased
    -moz-osx-font-smoothing: grayscale
    padding: 0 10px

    &:after
      position: absolute
      left: 0
      top: -14px
      font-size: 12px

  td
    font-size: 30px
    font-weight: 200
    width: auto
    padding: 10px
    max-width: 400px
    overflow: hidden

  .label
    font-weight: normal
    font-size: 16 px
  
  .price
    font-weight: 200
    
  .cur
    font-size: 15px
    font-weight: normal
    max-width: 100%
    
  .pos
    color: #1dcc5a

  .neg
    color: #cf1111
"""


render: -> """
  <table><tr><td>Loading...</td></tr></table>
"""


update: (output, domEl) ->
  try
    res = JSON.parse(output)
  catch e
    return

  data = Object.keys(res.DISPLAY).map((k) -> res.DISPLAY[k])
  console.log data
  table  = $(domEl).find('table')
  table.html ""

  renderCurrency = (label, price, change, state) ->
    """
    <td>
      <div>
        <span class=label> #{label}</span> <br>
        <div class="price">#{price}</div>
        <div class='cur #{state}'> #{change}%</div>
      </div>
    </td>
    """

  for value, i in data
    label = cryptos_to_watch[i]
    price = data[i][currency]['PRICE']
    change = data[i][currency]['CHANGEPCT24HOUR']
    state = if (change.charAt(0) == '-') then 'neg' else 'pos'
    if i % 3 == 0
      table.append "<tr/>"
    table.find("tr:last").append renderCurrency(label, price, change, state)

