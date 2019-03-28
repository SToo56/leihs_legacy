class window.App.HandOverController extends Spine.Controller

  elements:
    "#status": "status"
    "#lines": "reservationsContainer"

  events:
    "click [data-hand-over-selection]": "handOver"
    "click #swap-user": "swapUser"

  constructor: ->
    super
    @lineSelection = new App.LineSelectionController
      el: @el
      markVisitLinesController: new App.MarkVisitLinesController {el: @el}
      user: @user
      visitType: "handOver"
    @fetchFunctionsSetup
      "Model": "Item"
      "Software": "License"
    do @initalFetch
    new App.SwapModelController {el: @el, user: @user}
    new App.ReservationsDestroyController {el: @el}
    new App.ReservationAssignItemController {el: @el}
    new App.TimeLineController {el: @el}
    new App.ReservationAssignOrCreateController {el: @el.find("#assign-or-add"), user: @user}
    new App.ReservationsEditController {el: @el, user: @user, hand_over: true}
    new App.OptionLineChangeController {el: @el}
    new App.ModelCellTooltipController {el: @el}

  delegateEvents: =>
    super
    App.Reservation.on "change destroy refresh", (data)=>
      if data?.option_id? then @render(true) else do @fetchAvailability

    App.Reservation.on "update", (data)=>
      fi = @fetchItems() if @notFetchedItemIds().length
      fl = @fetchLicenses() if @notFetchedLicenseIds().length
      if fi or fl
        $.when(fi, fl).done => @render(@initialAvailabilityFetched?)
      else
        @render(@initialAvailabilityFetched?)

  initalFetch: =>
    if @getLines().length
      if @notFetchedItemIds().length
        @fetchItems()
      if @notFetchedLicenseIds().length
        @fetchLicenses()
      @fetchAvailability()

  fetchAvailability: =>
    @render false
    ids = _.uniq(_.map(_.filter(@getLines(), (l)-> l.model_id?), (l)->l.model().id))
    if ids.length
      @status.html App.Render "manage/views/availabilities/loading"
      App.Availability.ajaxFetch
        data: $.param
          model_ids: ids
          user_id: @user.id
      .done (data)=>
        @initialAvailabilityFetched = true
        @status.html App.Render "manage/views/availabilities/loaded"
        @render true
    else
      @status.html App.Render "manage/views/users/hand_over/no_handover_found"

  getLines: => App.Reservation.all()

  fetchFunctionsSetup: (classTypePairs) =>
    # macro for providing functions like 'notFetchedItemIds' and 'fetchItems'

    filterHelper = (modelClass, itemClass) =>
      _.filter _.compact(_.map(@getLines(), (l) -> if l.model().constructor.name == modelClass then l.item_id else null)), (id) -> not App[itemClass].exists(id)?

    fetchHelper = (className, ids) =>
      App[className].ajaxFetch
        data: $.param
          ids: ids
          paginate: 'false'

    _.each classTypePairs, (itemClassName, modelClassName) =>
      filterFunctionName = "notFetched" + itemClassName + "Ids"
      this[filterFunctionName] = => filterHelper modelClassName, itemClassName
      this["fetch" + itemClassName + "s"] = => fetchHelper itemClassName, do this[filterFunctionName]

  render: (renderAvailability)=>
    @reservationsContainer.html App.Render "manage/views/reservations/grouped_lines_with_action_date", App.Modules.HasLines.groupByDateRange(@getLines(), false, "start_date"),
      linePartial: "manage/views/reservations/hand_over_line"
      renderAvailability: renderAvailability
    do @lineSelection.restore

  handOver: =>
    if @validate()
      HandOverDialogUtil.loadHandOverDialogData({
        user: @user,
        reservations: (App.Reservation.find id for id in App.LineSelectionController.selected),
      }, (reservations, purpose) =>
        new App.HandOverDialogController(reservations, @user, purpose, => @lineSelection.clearLocalStorage())
      )
    else
      App.Flash
        type: "error"
        message: _jed('End Date cannot be in the past')

  swapUser: =>
    reservations = (App.Reservation.find id for id in App.LineSelectionController.selected)
    new App.SwapUsersController
      reservations: reservations
      user: @user

  validate: =>
    reservations = (App.Reservation.find id for id in App.LineSelectionController.selected)
    _.all reservations, (line)->
      # checking if end_date are in the past
      not moment(line.end_date).isBefore(moment().format("YYYY-MM-DD"))
