Ext.define("Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.CalendarEventsCreator", {
    extend: 'Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.BaseCreator',
    xtype: 'applicationmanagementbusinessmoduleformcalendareventscreator',

    /**
     * {String} creatorKlass
     * The class used to create the module.
     */
    creatorKlass: 'CompassAeBusinessSuite::BusinessModules::Creator::CalendarEvents',

    parentModuleType: 'file_name',

    title: 'Create CalendarEvents Module'
});

Ext.define("Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.CalendarEventsAssociator", {
    extend: 'Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.BaseAssociator',
    xtype: 'applicationmanagementbusinessmoduleformcalendareventsassociator',

    /**
     * {String} associatorKlass
     * The class used to associate the module.
     */
    associatorKlass: 'CompassAeBusinessSuite::BusinessModules::Associator::CalendarEvents',

    parentModuleType: 'file_name',

    title: 'Associate CalendarEvents Module'
});