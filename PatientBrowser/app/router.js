import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('patient');
  this.route('about');
});

export default Router;

/* need a objects for:
    vitals/observations (possibly combine with Lab)
      need most recent temperature, weight. Any others needed?
    problem list - FHIR resource Condition
    medication - FHIR resource MedicationOrder
    allergy - FHIR resource AllergyIntolerance
    lab result - FHIR resource Observation

    need collection for each of the above. Sort by date
*/
