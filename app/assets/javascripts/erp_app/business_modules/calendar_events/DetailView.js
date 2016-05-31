Ext.define("Compass.ErpApp.BusinessModules.CalendarEvents.DetailView", {
    extend: "Compass.ErpApp.Shared.BusinessModule.DetailView",
    alias: 'widget.calendareventsdetailview',

    /**
     * Update details tabpanel to title's description if the field exists
     * this should be overridden by specialized component
     */
    setTabTitle: function () {
        var me = this;

        if (me.isCreateForm) {
            me.setTitle('Create Calendar Events');
        }
        else {
            me.setTitle('Edit Calendar Events # ' + me.recordData['id']);
        }
    }
});
