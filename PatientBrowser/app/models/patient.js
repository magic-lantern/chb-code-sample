import DS from 'ember-data';
import Ember from 'ember';
import moment from 'moment';
import ENV from '../config/environment';

export default DS.Model.extend({
  patientId: DS.attr('string'),
  formatted_name: DS.attr('string'),
  last_name: DS.attr('string'),
  gender: DS.attr('string'),
  birthDate: DS.attr('date'),
  formatted_address: DS.attr('string'),
  age_value: DS.attr('number'),
  age_unit: DS.attr('string', { defaultValue: 'years' }),
  temp: {},
  weight: {},
  height: {},
  bloodpressure: {
    diastolic: {},
    systolic: {}
  },
  medications: DS.attr('raw', { defaultValue: function() { return []; } }),
  allergies: DS.attr('raw', { defaultValue: function() { return []; } }),
  conditions: DS.attr('raw', { defaultValue: function() { return []; } }),
  labs: DS.attr('raw', { defaultValue: function() { return []; } }),
  encounters: DS.attr('raw', { defaultValue: function() { return []; } }),
  hasPenicillinAllergy: DS.attr('boolean'),
  birthDateChanged: Ember.observer('birthDate', function() {
    var retval = 0;
    if (!Ember.isNone(this.get('birthDate'))) {
      var bday = moment(this.get('birthDate'), ENV.APP.date_format);
      retval = moment().diff(bday, 'years');
      if (retval <= 2) {
        this.set('age_value', moment().diff(bday, 'months'));
        this.set('age_unit', 'months');
      }
      else {
        this.set('age_value', retval);
        this.set('age_unit', 'years');
      }
    }
  }),
});
