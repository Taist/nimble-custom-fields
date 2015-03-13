React = require 'react'

{ div, a, input } = React.DOM

NimbleAlert = React.createFactory React.createClass
  render: ->
    div {
      style:
        position: 'fixed'
        left: 0;
        top: 0;
        width: '100%'
        height: '100%'
        zIndex: 1024
      onClick: (event) -> event.preventDefault()
    },
      div { style:
        width: '100%'
        height: '100%'
        backgroundColor: 'black'
        opacity: 0.1
      }
      div {
        className: 'nmbl-NimbleModalDialog nmbl-NimbleModalDialog-nmbl-ConfirmDialog'
        style:
          top: '50%'
          left: '50%'
          transform: 'translate(-50%, -50%)'
          position: 'absolute'
          overflow: 'visible'
      },
        div { className: 'popupContent' },
          div {},
            div { className: 'shadow' },
              div { className: 'border' },
                div { className: 'caption' },
                  div { className: 'captionText' }, @props.title or 'Warning'
                  div { className: 'close', onClick: @props.onCancel, dangerouslySetInnerHTML: __html: '&nbsp;' }
                  div { className: 'nmbl-floatBraker', dangerouslySetInnerHTML: __html: '&nbsp;' }
                div { className: 'content' },
                  div { className: 'dialogContents' },
                    div { className: 'nmbl-ConfirmDialog', style: { width: 300 } },
                      div { className: 'confirmText' }, @props.message
                      div { className: 'buttons' },
                        div { className: 'nmbl-Button nmbl-Button-WebkitGecko nmbl-Button-red' },
                          div { className: 'nmbl-ButtonContent', onClick: @props.onAction }, @props.actionName
                        div { className: 'nmbl-Button nmbl-Button-WebkitGecko' },
                          div { className: 'nmbl-ButtonContent', onClick: @props.onCancel }, 'Cancel'
                        div { className: 'nmbl-floatBraker', dangerouslySetInnerHTML: __html: '&nbsp;' }

module.exports = NimbleAlert
