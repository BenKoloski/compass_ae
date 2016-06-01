// Ext.ns('Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleProperties.file_name').misc = {
//     fields: [{
//         xtype: 'checkbox',
//         fieldLabel: 'Show Calendar',
//         name: 'show_calendar_view'
//     }, {
//         xtype: 'checkbox',
//         fieldLabel: 'Show Gantt',
//         name: 'show_gantt_view'
//     }],
//     setFields: function(metaData, form) {
//         form.getForm().findField('show_calendar_view').setValue(metaData['show_calendar_view']);
//         form.getForm().findField('show_gantt_view').setValue(metaData['show_gantt_view']);
//     }
// };

Ext.ns("Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleProperties.file_name").types = {
    fields: [{
        title: 'Select Task Types',
        itemId: 'taskType',
        xtype: 'typeselectiontree',
        typesUrl: '/api/v1/calendar_event_types',
        height: 280,
        name: 'calendar_event_type',
        typesRoot: 'work_effort_types',
        canCreate: true
    }],

    setFields: function(metaData, form) {
        var typesSelectionTree = form.down('#taskType');
        var availableStatuses = [];

        var stores = [
            typesSelectionTree.getStore()
        ];

        Compass.ErpApp.Utility.onStoresLoaded(stores, function() {
            if (metaData['calendar_event_type']) {
                typesSelectionTree.setSelectedTypes(metaData['calendar_event_type'] || '');
            }
        });
    }
};

// Ext.ns("Compass.ErpApp.Desktop.Applications.ApplicationManagement.BusinessModuleProperties.file_name").eastRegion = {
//     fields: [{
//         layout: 'hbox',
//         items: [{
//             xtype: 'displayfield',
//             fieldLabel: 'Task Types',
//             name: 'task_types',
//             itemId: 'task_types',
//         }, {
//             xtype: 'tbfill'
//         }, {
//             xtype: 'applicationmanagementadvancedbutton',
//             activeTab: 'moduleTypesForm'
//         }]
//     }, {
//         layout: 'hbox',
//         items: [{
//             xtype: 'displayfield',
//             fieldLabel: 'Completed Statuses',
//             name: 'completed_statuses',
//             itemId: 'completed_statuses',
//         }, {
//             xtype: 'tbfill'
//         }, {
//             xtype: 'applicationmanagementadvancedbutton',
//             activeTab: 'moduleTypesForm'
//         }]
//     }],

//     setFields: function(metaData, form) {

//         var typesSelectionField = form.down('#task_types');
//         var completedStatusField = form.down('#completed_statuses');

//         var workEffortTypes = Ext.Array.map(metaData.work_effort_type.split(','), function(workEffortType) {
//             return workEffortType.replace(/_/g, ' ').replace(/(?: |\b)(\w)/g, function(key) {
//                 return key.toUpperCase();
//             });
//         }).join(',');

//         var completedStatuses = Ext.Array.map(metaData.completed_status.split(','), function(completedStatus) {
//             return completedStatus.replace(/_/g, ' ').replace(/(?: |\b)(\w)/g, function(key) {
//                 return key.toUpperCase();
//             });
//         }).join(',');

//         typesSelectionField.setValue(Ext.String.ellipsis(workEffortTypes.replace(/\,$/, ''), 24));

//         completedStatusField.setValue(Ext.String.ellipsis(completedStatuses.replace(/\,$/, ''), 24));

//         /*
//          * Had to add the quick tip on render and if the el is rendered.  ExtJs was
//          * not adding the quick tip if the field was rendered twice
//          */

//         typesSelectionField.on('render', function(comp) {
//             Ext.QuickTips.register({
//                 target: comp.getEl(),
//                 text: workEffortTypes.replace(/\,$/, '')
//             });
//         });

//         if (typesSelectionField.getEl()) {
//             Ext.QuickTips.register({
//                 target: typesSelectionField.getEl(),
//                 text: workEffortTypes.replace(/\,$/, '')
//             });
//         }

//         completedStatusField.on('render', function(comp) {
//             Ext.QuickTips.register({
//                 target: comp.getEl(),
//                 text: completedStatuses.replace(/\,$/, '')
//             });
//         });

//         if (completedStatusField.getEl()) {
//             Ext.QuickTips.register({
//                 target: completedStatusField.getEl(),
//                 text: completedStatuses.replace(/\,$/, '')
//             });
//         }
//     }
// };

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