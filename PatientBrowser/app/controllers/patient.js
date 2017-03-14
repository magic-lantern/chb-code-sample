import Ember from 'ember';

export default Ember.Controller.extend({
  sortProperties: ['last_name:asc'],
  sortedPatients: Ember.computed.sort('model', 'sortProperties'),
  currentPatient: null,
  actions: {
    viewPatient: function(patient) {
      var elem = Ember.$('#li_' + patient.get('patientId'));
      // remove active class from all others
      elem.siblings().removeClass('active');
      // turn on active class for this item
      elem.addClass('active');
      this.set('currentPatient', patient);
    },
    selectPatient: function(patient) {
      var fc = this.get('fc');
      var elem = Ember.$('#check_' + patient.get('patientId'));
      // if selected class exits, remove from list
      if (elem.hasClass('selected')) {
        fc.unselectPatient(patient.get('patientId'));
      }
      else {
        fc.selectPatient(patient.get('patientId'));
      }
      elem.toggleClass('selected');
    }
  }
});
