Ext.define("Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.EventCalendarCreator", {
    extend: 'Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.BaseCreator',
    xtype: 'applicationmanagementbusinessmoduleformeventcalendarcreator',

    /**
     * {String} creatorKlass
     * The class used to create the module.
     */
    creatorKlass: 'CompassAeBusinessSuite::BusinessModules::Creator::EventCalendar',

    parentModuleType: 'file_name',

    title: 'Create EventCalendar Module'
});

Ext.define("Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.EventCalendarAssociator", {
    extend: 'Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleForm.BaseAssociator',
    xtype: 'applicationmanagementbusinessmoduleformeventcalendarassociator',

    /**
     * {String} associatorKlass
     * The class used to associate the module.
     */
    associatorKlass: 'CompassAeBusinessSuite::BusinessModules::Associator::EventCalendar',

    parentModuleType: 'file_name',

    title: 'Associate EventCalendar Module'
});