module.exports =
  registerHandler: (responseHandler) ->

    XMLHttpRequestSend = XMLHttpRequest::send
    XMLHttpRequest::send = ->
      onReady = @onreadystatechange
      self = this

      @onreadystatechange = () ->
        if self.readyState is 4
          responseHandler self

        onReady and onReady.apply(self, arguments)
        return

      XMLHttpRequestSend.apply this, arguments
      return
