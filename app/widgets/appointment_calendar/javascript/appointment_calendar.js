Compass.ErpApp.Widgets.AppointmentCalendar = {
	addWidget:function(){
        Ext.getCmp('knitkitCenterRegion').addContentToActiveCodeMirror('<%= render_widget :appointment_calendar %>');
	}
};

Compass.ErpApp.Widgets.AvailableWidgets.push({
    name:'Appointment Calendar',
    iconUrl:'icon.jpg',
    onClick:Compass.ErpApp.Widgets.AppointmentCalendar.addWidget,
    about:"Appointment Calendar"
});