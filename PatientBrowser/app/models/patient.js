import DS from 'ember-data';

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
  medications: [],
  allergies: [],
  conditions: [],
  labs: [],
  encounters: [],
  hasPenicillinAllergy: DS.attr('boolean'),
});
