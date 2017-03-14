import Ember from 'ember';

export default Ember.Component.extend({
  encounters: null,
  index: 0,
  shouldShow: false,
  start: null,
  text: null,
  onChange: function () {
    if(!Ember.isEmpty(this.encounters) && !Ember.isEmpty(this.encounters[this.index])){
      for (let i in this.encounters[this.index]) {
        this.set(i, this.encounters[this.index][i]);
      }
      this.set('shouldShow', true);
    }
    else {
      this.set('start', null);
      this.set('text', null);
      this.set('shouldShow', false);
    }
  }.observes('encounters'),
});
