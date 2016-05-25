Compass.ErpApp.Widgets.AppointmentCalendar = {
	addWidget:function(){
        Ext.getCmp('knitkitCenterRegion').addContentToActiveCodeMirror('<%= render_widget :appointment_calendar %>');
	}
};

Compass.ErpApp.Widgets.AvailableWidgets.push({
    name:'Appointment Calendar',
    iconUrl:'/assets/icons/product/product_48x48.png',
    onClick:Compass.ErpApp.Widgets.AppointmentCalendar.addWidget,
    about:"Appointment Calendar"
});