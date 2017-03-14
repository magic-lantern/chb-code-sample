import Ember from 'ember';

export default Ember.Component.extend({
  highlight_color: null,
  conditions: null,
  text: null,
  date: null,
  index: 0,
  shouldShow: false,
  onChange: function() {
    if(!Ember.isEmpty(this.conditions) && !Ember.isEmpty(this.conditions[this.index])){
      for (let i in this.conditions[this.index]) {
        this.set(i, this.conditions[this.index][i]);
      }
      this.set('shouldShow', true);
    }
    else {
      this.set('text', null);
      this.set('date', null);
      this.set('shouldShow', false);
    }
  }.observes('conditions'),
});
