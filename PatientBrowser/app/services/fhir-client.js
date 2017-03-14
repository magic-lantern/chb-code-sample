/* global FHIR */
import Ember from 'ember';
import moment from 'moment';
import ENV from '../config/environment';

export default Ember.Service.extend({
  patientList: [],
  selectedPatients: null,
  patientContext: null,
  fhirclient: null,
  fhirPatient: null,
  isLoading: true,
  fhirFailed: false,
  store: Ember.inject.service(),

  init() {
    // this not available in callbacks
    var self = this;
    this._super(...arguments);

    // wait up to 10 seconds for everything to work. If fails, use fake patient data
    var timeout = setTimeout(function() {
      self.set('fhirFailed', true);
      self.set('isLoading', false);
      self.loadPatient('demo');
    }, 5000);

    // this line prevents the addition of a timestamp to the fhir-client.js file
    Ember.$.ajaxSetup({cache: true});
    // calling this creates the global FHIR object
    Ember.$.getScript("/js/fhir-client.js")
    .done(function() {
      var fhirclient = FHIR.client({
        'serviceUrl': ENV.APP.serviceUrl,
        'auth' : {
          type: 'none'
        }
      });
      self.set('fhirclient', fhirclient);
      fhirclient.api.search({
        'type': 'Patient',
        'named' : '$everything'
      }).done(function(patientList){
        self.set('patientList', patientList);
        var store = self.get('store');
        console.log('results');
        console.log(patientList);
        if (!Ember.isNone(patientList.data.entry)) {
          patientList.data.entry.forEach(function(patient) {
            console.log(patient);
            var pr = patient.resource;
            var address;
            if(!Ember.isNone(pr.address)) {
              address = pr.address[0].line[0] + ', ' + pr.address[0].city + ', ' + pr.address[0].state;
            }
            var patientret = store.createRecord('patient', {
              'patientId': pr.id,
              'formatted_name' : pr.name[0].given.join(" ") + " " + pr.name[0].family[0],
              'last_name' : pr.name[0].family[0],
              'gender' : pr.gender,
              'birthDate' : pr.birthDate,
              'formatted_address' : address,
            });
            // rest of data requires more FHIR call(s)
            self.readPatient(patientret);
          });
        }
        // now that all processing has completed successfully, clear timeout and loading flag
        clearTimeout(timeout);
        self.set('isLoading', false);
      })
      .fail(function(){
        console.log('called fail function from search');
        self.set('fhirFailed', true);
      });
      console.log("service - FHIR script loaded successfully.");
    })
    .fail(function() {
      console.log("service - FHIR script FAILED to load.");
    });
  },
  readPatient: function(patient) {
    var self = this;
    Ember.$.get( ENV.APP.serviceUrl + '/Patient/' + patient.get('patientId') + '/$everything', function() {
    })
    .done(function(data) {
      data.entry.forEach(function(entry) {
        console.log('entry');
        if (entry.resource.resourceType === 'Condition') {
          self.readConditions(entry, patient);
        }
        else if (entry.resource.resourceType === 'MedicationOrder') {
          self.readMedications(entry, patient);
        }
        else if (entry.resource.resourceType === 'AllergyIntolerance') {
          self.readAllergies(entry, patient);
        }
        else if (entry.resource.resourceType === 'Encounter') {
          self.readEncounters(entry, patient);
        }
        // need to add check for other resource types
      });
    })
    .fail(function() {
      console.log( "readPatient error" );
    });
  },
  readConditions: function(condition, patient) {
    var c = condition.resource;
    var r = {};
    r.code = c.code.coding[0].code;
    r.text = c.code.text;
    r.date = c.onsetDateTime;
    var pc = patient.get('conditions');
    pc.push(r);
  },
  readMedications: function(medication, patient) {
    var m = medication.resource;
    var r = {};
    r.display = m.medicationCodeableConcept.coding[0].display;
    r.code = m.medicationCodeableConcept.coding[0].code;
    r.dosageInstruction = m.dosageInstruction[0].text;
    if (!Ember.isNone(m.dosageInstruction[0].timing)) {
      r.date = m.dosageInstruction[0].timing.repeat.boundsPeriod.start;
    }
    if (!Ember.isNone(m.dispenseRequest)) {
      r.duration_value = m.dispenseRequest.expectedSupplyDuration.value;
      r.duration_unit = m.dispenseRequest.expectedSupplyDuration.unit;
      r.refills = m.dispenseRequest.numberOfRepeatsAllowed;
    }
    var pm = patient.get('medications');
    pm.push(r);
  },
  readAllergies: function(allergy, patient) {
    var a = allergy.resource;
    var r = {};
    r.severity = a.reaction[0].severity;
    r.manifestation = a.reaction[0].manifestation[0].text;
    r.category = a.category;
    r.date = a.recordedDate;
    r.substance = a.substance.text;
    r.text = a.text.div;
    var pa = patient.get('allergies');
    pa.push(r);
  },
  readEncounters: function(encounter, patient) {
    var e = encounter.resource;
    var r = {};
    r.class = e.class;
    r.text = e.text.div.replace('<div xmlns="http://www.w3.org/1999/xhtml">', '')
      .replace('</div>', '')
      .replace(e.period.start + ': ', '');
    r.start = e.period.start;
    r.end = e.period.end;
    var pe = patient.get('encounters');
    pe.push(r);
  },
  selectPatient: function(patientId) {
    var selectedPatients;
    if (Ember.isEmpty(this.get('selectedPatients'))) {
      selectedPatients = new Set();
      this.set('selectedPatients', selectedPatients);
    }
    else {
      selectedPatients = this.get('selectedPatients');
    }
    selectedPatients.add(patientId);
  },
  unselectPatient: function(patientId) {
    var selectedPatients;
    if (Ember.isEmpty(this.get('selectedPatients'))) {
      selectedPatients = new Set();
      this.set('selectedPatients', selectedPatients);
    }
    else {
      selectedPatients = this.get('selectedPatients');
    }
    selectedPatients.delete(patientId);
  }
});
