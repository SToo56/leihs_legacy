(() => {
  // NOTE: only for linter and clarity:
  /* global _ */
  /* global _jed */
  const React = window.React
  const ReactDOM = window.ReactDOM
  const Autocomplete = window.ReactAutocomplete
  React.findDOMNode = ReactDOM.findDOMNode // NOTE: autocomplete lib needs this

  window.FieldAutocomplete = window.createReactClass({
    propTypes: {
    },

    name: 'FieldAutocomplete',

    _onChange(result) {
      if(this.props.onChange) {
        this.props.onChange(result)
      }
    },

    _makeCall(term, callback) {
      this.props.doSearch(term, (result) => {
        callback(result)
      })
    },

    render () {
      return (
        <div className='col1of2' data-type='value'>
          <BasicAutocomplete
            inputClassName='has-addon width-full ui-autocomplete-input ui-autocomplete-loading'
            element='label'
            inputId={null}
            dropdownWidth='350px'
            label={this.props.label}
            _makeCall={this._makeCall}
            onChange={this._onChange}
            initialText={this.props.initialText}
            name={this.props.name}
          />
        </div>
      )
    }
  })
})()
