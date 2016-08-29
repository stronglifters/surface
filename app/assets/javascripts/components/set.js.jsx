var Set = React.createClass({
  getInitialState: function() {
    return { message: '' };
  },
  handleClick: function() {
    model = this.model();
    if (model.started()) {
      model.decrement();
    } else {
      model.complete();
    }
    model.save();

    this.setState({ actual_repetitions: model.get('actual_repetitions') });
    if ( model.successful() ) {
      if (model.workSet()) {
        this.setState({
          message: "If it was easy break for 1:30, otherwise rest for 3:00."
        });
      } else {
        this.setState({
          message: "No rest for the wicked. Let's do this!"
        });
      }
    } else {
      this.setState({ message: "Take a 5:00 break." });
    }
  },
  render: function(){
    model = this.model();
    return (
      <div className="row">
        <div className="columns">
          <button onClick={this.handleClick} className="button">{model.get('actual_repetitions')}</button>
        </div>
        <div className="columns">
          <p className="text-center">{model.get('target_repetitions')} x {model.get('target_weight')}</p>
        </div>
        <div className="columns">
          <p className="text-center">{model.get('weight_per_side')}</p>
        </div>
      </div>
    );
  },
  model: function() {
    return this.props.model;
  }
});
