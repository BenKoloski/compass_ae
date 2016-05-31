Ext.define("Compass.ErpApp.BusinessModules.CalendarEvents.ListView", {
    extend: "Compass.ErpApp.Shared.BusinessModule.ListView",
    alias: 'widget.calendareventslistview',

    /**
     * @cfg {String} title
     * title of panel.
     */
    title: 'Calendar Events',

    /**
     * @cfg {string} detailViewXtype
     * xtype for detail view
     */
    detailViewXtype: 'calendareventsdetailview'
});
