var Set = React.createClass({
  handleClick: function() {
    model = this.model();
    if (model.started()) {
      model.decrement();
    } else {
      model.complete();
    }
    model.save();

    this.setState({ actual_repetitions: this.props.model.get('actual_repetitions') });
  },
  render: function(){
    return (
      <tr>
        <td>{this.model().get('type')}</td>
        <td><button onClick={this.handleClick} type="button" className="button">{this.model().get('actual_repetitions')}</button></td>
        <td>{this.model().get('target_repetitions')} x {this.model().get('target_weight')}</td>
        <td>{this.model().get('weight_per_side')}</td>
      </tr>
    );
  },
  model: function() {
    return this.props.model;
  }
});

