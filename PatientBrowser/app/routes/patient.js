import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel: function() {
    if (this.get('fc.isLoading')) {
      this.transitionTo('index');
    }
  },
  model() {
    return this.store.peekAll('patient');
  },
});
