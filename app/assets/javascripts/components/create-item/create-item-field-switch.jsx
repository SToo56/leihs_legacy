;(() => {
  // NOTE: only for linter and clarity:
  /* global _, _jed, moment, accounting, i18n, React, PropTypes, App, CreateItemFieldSwitch, RenderFieldLabel, InputInventoryCode, InputCheckbox, InputInventoryCode, InputQuantityAllocations, InputAttachment, InputText, InputAutocompleteSearch, InputAutocomplete, InputTextarea, InputSelect, InputRadio, InputDate, InputCheckbox */

  window.CreateItemFieldSwitch = {
    // contextTypes: {
    //   isBatchCreate: PropTypes.bool
    // },

    _hasValue(selectedValue) {
      if (selectedValue.field.id == 'properties_quantity_allocations') {
        return selectedValue.value.allocations.length > 0
      }

      switch (selectedValue.field.type) {
        case 'text':
          return selectedValue.value.text.trim().length > 0
        case 'autocomplete-search':
          return selectedValue.value.id != null || selectedValue.value.text != ''
        case 'autocomplete':
          return selectedValue.value.id != null || selectedValue.value.text != ''
        case 'textarea':
          return selectedValue.value.text.trim().length > 0
        case 'select':
          return selectedValue.value.selection != null && selectedValue.value.selection != ''
        case 'radio':
          return selectedValue.value.selection != null
        case 'date':
          return selectedValue.value.at.trim().length > 0
        case 'checkbox':
          return selectedValue.value.selections.length > 0
        case 'attachment':
          return selectedValue.value.fileModels.length > 0
        default:
          throw 'Unexpected type: ' + selectedValue.field.type
      }
    },

    _dmyToString(dmy) {
      if (dmy) {
        var dayString = '' + (dmy.day + 1)
        var monthString = '' + (dmy.month + 1)
        var yearString = '' + dmy.year

        if (dayString.length == 1) {
          dayString = '0' + dayString
        }
        if (monthString.length == 1) {
          monthString = '0' + monthString
        }

        return yearString + '-' + monthString + '-' + dayString
      } else {
        return null
      }
    },

    _parseSavedDate(string) {
      var mom = moment(string, 'YYYY-MM-DD', true)
      if (!mom.isValid()) {
        return string
      } else {
        return mom.format(i18n.date.L)
      }
    },

    _parseDayMonthYear(string) {
      if (!string) {
        return null
      }

      var mom = moment(string, i18n.date.L, true)

      if (!mom.isValid()) {
        return null
      }

      return this._getDayMonthYear(mom)
    },

    _getDayMonthYear(mom) {
      return {
        day: mom.date() - 1,
        month: mom.month(),
        year: mom.year()
      }
    },

    _checkDateStringIsValid(d) {
      return moment(d, i18n.date.L, true).isValid()
    },

    _isValid(selectedValue) {
      if (selectedValue.field.type == 'date') {
        var d = selectedValue.value.at
        return this._checkDateStringIsValid(d)
      } else if (selectedValue.field.type == 'autocomplete') {
        return (
          (selectedValue.value.text != '' && selectedValue.value.id) ||
          (selectedValue.value.text == '' && !selectedValue.value.id)
        )
      } else if (selectedValue.field.type == 'autocomplete-search') {
        return (
          (selectedValue.value.text != '' && selectedValue.value.id) ||
          (selectedValue.value.text == '' && !selectedValue.value.id)
        )
      } else {
        return true
      }
    },

    _itemValue(attribute, item) {
      var itemValue = null
      if (attribute instanceof Array) {
        itemValue = _.reduce(
          attribute,
          (result, current) => {
            if (result) {
              return result[current]
            } else {
              return null
            }
          },
          item
        )
      } else {
        itemValue = item[attribute]
      }

      return itemValue
    },

    _createEditValue(field, item, itemValue, attachments) {
      if (field.id == 'retired') {
        itemValue = !!itemValue
      }

      if (field.id == 'properties_quantity_allocations') {
        return {
          allocations: itemValue.map((v) => {
            return {
              quantity: v.quantity,
              location: v.room,
              type: 'edit'
            }
          })
        }
      }

      var text

      switch (field.type) {
        case 'text':
          if (field.currency) {
            return {
              text: accounting.formatMoney(itemValue, { format: '%v' })
            }
          } else {
            return { text: itemValue }
          }
        case 'autocomplete-search':
          var base = this._itemValue(field.item_value_label, item)
          var ext = this._itemValue(field.item_value_label_ext, item)
          text = base + (ext ? ' ' + ext : '')
          return {
            text: text,
            id: itemValue
          }
        case 'autocomplete':
          text = null
          if (field.id == 'room_id') {
            // debugger
            text = item.room.name
          } else {
            if (itemValue) {
              var value = _.find(field.values, (v) => {
                return v.value == itemValue
              })
              if (value) text = value.label
            }
          }
          return {
            text: text,
            id: itemValue
          }
        case 'textarea':
          return { text: itemValue }
        case 'attachment':
          var fileModels = attachments.map((a) => {
            return {
              type: 'edit',
              id: a.id,
              public_filename: a.public_filename,
              filename: a.filename,
              delete: false,
              content_type: a.content_type
            }
          })
          return { fileModels: fileModels }
        case 'select':
          // TODO read mapping to values from field definition
          // debugger
          return { selection: itemValue }
        case 'radio':
          return { selection: itemValue }
        case 'checkbox':
          return { selections: itemValue }
        case 'date':
          return { at: this._parseSavedDate(itemValue) }
        default:
          throw 'Unexpected type: ' + field.type
      }
    },

    _createEmptyValue(field) {
      if (field.id == 'properties_quantity_allocations') {
        return {
          allocations: []
        }
      }

      switch (field.type) {
        case 'text':
          return { text: '' }
        case 'autocomplete-search':
          return {
            text: '',
            id: null
          }
        case 'autocomplete':
          return {
            text: '',
            id: null
          }
        case 'textarea':
          return { text: '' }
        case 'attachment':
          return { fileModels: [] }
        case 'select':
          return { selection: field.default }
        case 'radio':
          return { selection: field.default }
        case 'date':
          return { at: '' }
        case 'checkbox':
          return { selections: [] }
        default:
          throw 'Unexpected type ' + field.type + ' for field ' + field.id
      }
    },

    _hasValidValue(selectedValue) {
      return (
        CreateItemFieldSwitch._hasValue(selectedValue) &&
        CreateItemFieldSwitch._isValid(selectedValue)
      )
    },

    _isDependencyValue(selectedValue, fieldDependencyValue) {
      if (!fieldDependencyValue) {
        return this._hasValidValue(selectedValue)
      }

      switch (selectedValue.field.type) {
        case 'text':
          return selectedValue.value.text == fieldDependencyValue
        case 'autocomplete-search':
          return selectedValue.value.text == fieldDependencyValue
        case 'autocomplete':
          return selectedValue.value.id == fieldDependencyValue
        case 'textarea':
          return selectedValue.value.text == fieldDependencyValue
        case 'select':
          return '' + selectedValue.value.selection == fieldDependencyValue
        case 'radio':
          return '' + selectedValue.value.selection == fieldDependencyValue
        // case 'checkbox':
        //   return true
        //   break
        case 'date':
          throw 'Not implemented yet for date.'
        default:
          throw 'Unexpected type: ' + selectedValue.field.type
      }
    },

    _outputByType(selectedValue) {
      if (selectedValue.field.id == 'properties_quantity_allocations') {
        return (
          <div className="col1of2" data-type="value">
            <div className="padding-vertical-xs font-size-m" data-value="invoice">
              <span>Only visible if owner</span>
            </div>
          </div>
        )
      }

      var type = selectedValue.field.type
      var label, value

      if (type == 'text' || type == 'textarea') {
        return (
          <div className="col1of2" data-type="value">
            <div className="padding-vertical-xs font-size-m" data-value="invoice">
              <span>{selectedValue.value.text}</span>
            </div>
          </div>
        )
      } else if (type == 'date') {
        return (
          <div className="col1of2" data-type="value">
            <div className="padding-vertical-xs font-size-m" data-value="invoice">
              <span>{selectedValue.value.at}</span>
            </div>
          </div>
        )
      } else if (type == 'radio' || type == 'select') {
        label = _.find(selectedValue.field.values, (value) => {
          return value.value == selectedValue.value.selection
        }).label

        return (
          <div className="col1of2" data-type="value">
            <div className="padding-vertical-xs font-size-m" data-value="invoice">
              <span>{_jed(label)}</span>
            </div>
          </div>
        )
      } else if (type == 'checkbox') {
        var labels = selectedValue.value.selections
          .map((s) => {
            var value = _.find(selectedValue.field.values, (value) => value.value == s)
            if (value) {
              return _jed(value.label)
            } else {
              return s
            }
          })
          .join(', ')

        return (
          <div className="col1of2" data-type="value">
            <div className="padding-vertical-xs font-size-m" data-value="invoice">
              <span>{labels}</span>
            </div>
          </div>
        )
      } else if (type == 'autocomplete') {
        value = selectedValue.value
        // _.find(selectedValue.field.values, (value) => {
        //   return value.value == selectedValue.value.id
        // })

        label = ''
        if (value) {
          label = value.text
        } else {
          // debugger
        }

        return (
          <div className="col1of2" data-type="value">
            <div className="padding-vertical-xs font-size-m" data-value="invoice">
              <span>{label}</span>
            </div>
          </div>
        )
      } else if (type == 'autocomplete-search') {
        value = selectedValue.value

        label = ''
        if (value) {
          label = value.text
        }

        return (
          <div className="col1of2" data-type="value">
            <div className="padding-vertical-xs font-size-m" data-value="invoice">
              <span>{label}</span>
            </div>
          </div>
        )
      } else {
        throw 'Not implemented for: ' + type
      }
    },

    _inputByType(selectedValue, onChangeSelectedValue, dependencyValue) {
      switch (selectedValue.field.type) {
        case 'text':
          return <InputText selectedValue={selectedValue} onChange={onChangeSelectedValue} />
        case 'autocomplete-search':
          return (
            <InputAutocompleteSearch
              onChange={onChangeSelectedValue}
              selectedValue={selectedValue}
            />
          )
        case 'autocomplete':
          return (
            <InputAutocomplete
              selectedValue={selectedValue}
              dependencyValue={dependencyValue}
              onChange={onChangeSelectedValue}
            />
          )
        case 'textarea':
          return <InputTextarea selectedValue={selectedValue} onChange={onChangeSelectedValue} />
        case 'select':
          return <InputSelect selectedValue={selectedValue} onChange={onChangeSelectedValue} />
        case 'radio':
          return <InputRadio selectedValue={selectedValue} onChange={onChangeSelectedValue} />
        case 'date':
          return <InputDate selectedValue={selectedValue} onChange={onChangeSelectedValue} />
        case 'checkbox':
          return <InputCheckbox selectedValue={selectedValue} onChange={onChangeSelectedValue} />
        // case 'attachment':
        //   return <InputAttachment selectedValue={selectedValue} onChange={onChangeSelectedValue} />
        //   break
        default:
          throw 'Unexpected type: ' + selectedValue.field.type
      }
    },

    _isFieldInvalid(fieldModel) {
      if (fieldModel.field.required) {
        return !this._hasValue(fieldModel) || !this._isValid(fieldModel)
      } else {
        return this._hasValue(fieldModel) && !this._isValid(fieldModel)
      }
    },

    _isFieldEditable(field, item) {
      if (!item) {
        return true
      }

      var editable

      editable = true

      if (field.permissions != null && typeof item !== 'undefined' && item !== null) {
        if (
          field.permissions.role != null &&
          !App.AccessRight.atLeastRole(App.User.current.role, field.permissions.role)
        ) {
          editable = false
        }
        if (
          field.permissions.owner != null &&
          field.permissions.owner &&
          item.owner != null &&
          App.InventoryPool.current.id !== item.owner.id
        ) {
          editable = false
        }
      }

      return editable
    },

    _renderFileRows(selectedValue) {
      return selectedValue.value.fileModels.map((fileModel, index) => {
        return this._renderFileRow(fileModel, index)
      })
    },

    _renderFilename(fileModel) {
      return (
        <a className="blue" href={fileModel.public_filename} target="_blank">
          {fileModel.filename}
        </a>
      )
    },

    _renderFileRow(fileModel, index) {
      return (
        <div
          key={'key_' + index}
          className="row line font-size-xs focus-hover-thin"
          data-type="inline-entry">
          <div className="line-col col7of10 text-align-left">{this._renderFilename(fileModel)}</div>
          <div className="line-col col3of10 text-align-right"></div>
        </div>
      )
    },

    _requiredString(selectedValue) {
      if (selectedValue.field.required) {
        return 'true'
      } else {
        return 'false'
      }
    },

    _renderOutputField(
      selectedValue,
      dependencyValue,
      dataDependency,
      onChange,
      showInvalids,
      onClose,
      config
    ) {
      var fieldClass
      if (selectedValue.field.type == 'attachment') {
        fieldClass = 'field row emboss padding-inset-xs margin-vertical-xxs margin-right-xs'
        if (selectedValue.hidden) {
          fieldClass += ' hidden'
        }

        return (
          <div
            className={fieldClass}
            data-editable="true"
            data-id="attachments"
            data-required={this._requiredString(selectedValue)}
            data-type="field">
            <div className="row">
              {RenderFieldLabel._renderFieldLabel(selectedValue.field, onClose, config.showClose)}
              <div className="col1of2" data-type="value">
                <div className="padding-vertical-xs font-size-m"></div>
              </div>
            </div>
            <div className="list-of-lines even padding-bottom-xxs">
              {this._renderFileRows(selectedValue)}
            </div>
          </div>
        )
      } else {
        fieldClass = 'field row emboss padding-inset-xs margin-vertical-xxs margin-right-xs'
        if (selectedValue.hidden) {
          fieldClass += ' hidden'
        }
        if (config && config.additionalRowClass) {
          fieldClass += ' ' + config.additionalRowClass
        }

        return (
          <div
            className={fieldClass}
            data-editable="false"
            data-id={selectedValue.field.id}
            data-required={this._requiredString(selectedValue)}
            data-type="field">
            <div className="row">
              {RenderFieldLabel._renderFieldLabel(selectedValue.field, onClose, config.showClose)}
              {this._outputByType(selectedValue)}
            </div>
          </div>
        )
      }
    },

    _renderInputField(
      selectedValue,
      dependencyValue,
      dataDependency,
      onChange,
      showInvalids,
      onClose,
      config
    ) {
      var error = showInvalids && this._isFieldInvalid(selectedValue)

      if (selectedValue.field.id == 'properties_quantity_allocations') {
        return (
          <InputQuantityAllocations
            onClose={onClose}
            selectedValue={selectedValue}
            dataDependency={dataDependency}
            onChange={onChange}
            error={error}
          />
        )
      } else if (selectedValue.field.id == 'inventory_code') {
        return (
          <InputInventoryCode
            onClose={onClose}
            selectedValue={selectedValue}
            onChange={onChange}
            inventoryCodeProps={null}
            error={error}
            editMode={true}
          />
        )
      } else if (selectedValue.field.type == 'attachment') {
        return (
          <InputAttachment
            onClose={onClose}
            selectedValue={selectedValue}
            onChange={onChange}
            error={error}
          />
        )
      } else {
        var fieldClass = 'field row emboss padding-inset-xs margin-vertical-xxs margin-right-xs'
        if (error) {
          fieldClass += ' error'
        }
        if (selectedValue.hidden) {
          fieldClass += ' hidden'
        }
        if (config && config.additionalRowClass) {
          fieldClass += ' ' + config.additionalRowClass
        }

        return (
          <div
            className={fieldClass}
            data-editable="true"
            data-id={selectedValue.field.id}
            data-required={this._requiredString(selectedValue)}
            data-type="field">
            <div className="row">
              {RenderFieldLabel._renderFieldLabel(selectedValue.field, onClose, config.showClose)}
              {this._inputByType(selectedValue, onChange, dependencyValue)}
            </div>
          </div>
        )
      }
    },

    renderField(
      selectedValue,
      dependencyValue,
      dataDependency,
      onChange,
      item,
      inventoryCodeProps,
      showInvalids,
      onClose,
      showClose
    ) {
      var isEditable = !item || (item && this._isFieldEditable(selectedValue.field, item))

      if (isEditable) {
        if (selectedValue.field.id == 'inventory_code' && !item) {
          var error = showInvalids && this._isFieldInvalid(selectedValue)
          return (
            <InputInventoryCode
              onClose={onClose}
              selectedValue={selectedValue}
              onChange={onChange}
              inventoryCodeProps={inventoryCodeProps}
              error={error}
              editMode={false}
            />
          )
        } else {
          return this._renderInputField(
            selectedValue,
            dependencyValue,
            dataDependency,
            onChange,
            showInvalids,
            onClose,
            { showClose: showClose }
          )
        }
      } else {
        return this._renderOutputField(
          selectedValue,
          dependencyValue,
          dataDependency,
          onChange,
          showInvalids,
          onClose,
          { showClose: showClose }
        )
      }
    }
  }

  window.CreateItemFieldSwitch.displayName = 'CreateItemFieldSwitch'
})()
